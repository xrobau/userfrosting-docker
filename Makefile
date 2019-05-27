HUB = hub.docker.com/xrobau
NAME = derp
BUILD ?= 01
UFPORT ?= 8086

VERSION := $(shell date +%Y%m%d).$(BUILD)

SSHAGENT = -v $(shell readlink -f ${SSH_AUTH_SOCK}):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent
PARAMS = --name=$(NAME) -p $(UFPORT):80 $(SSHAGENT) -e DEVMODE=true --network=uf_default $(MOUNTS) $(ENVVARS)

MOUNTS = -v $(shell pwd)/git/userfrosting:/var/www -v $(shell pwd)/git/userfrosting/public:/var/www/html

ENVVARS = -e DB_DRIVER=mysql -e DB_HOST=coredb -e DB_PORT=3306 -e DB_NAME=userfrosting -e DB_USER=userfrosting -e DB_PASSWORD=$(MYSQLUSERPASSWORD)

COMPOSERVERSION=1.23.1
WEBUSER=www-data

# Pull UserFrosting from git
PACKAGES := packages/userfrosting.tar.bz2

# Note that 'make nuke' does a 'git checkout --force' of these repositories.
# Don't use it unless you really need to.
USERFROSTING_REPO = git@github.com:userfrosting/UserFrosting.git
USERFROSTING_BRANCH = origin/master
USERFROSTING_MOUNT = /var/www/


.PHONY: all build run watch shell stop stopall stop-database start-prereq docker-start-database \
	load-passwords generate-passwords docker-compose link-packages fixperms

export

all: build run watch

build: $(PACKAGES) link-packages git/userfrosting/app/sprinkles.json
	docker build -t $(NAME):$(VERSION) --rm image

run: start-prereq stop
	docker run -it -d $(PARAMS) $(NAME):$(VERSION)

watch: git/userfrosting/app/vendor/autoload.php git/userfrosting/build/node_modules fixperms
	docker logs -f $(NAME)

# We do an 'update' here, because there's some incompatible .lock files that
# cause confusion inside composer. I didn't look where.
git/userfrosting/app/vendor/autoload.php:
	docker exec -it -w /var/www $(NAME) composer update

# We tag the package.json as a dep, so if it's updated we'll rebuild the mode modules
git/userfrosting/build/node_modules: git/userfrosting/build/package.json
	docker exec -it -w /var/www/build $(NAME) npm install

git/userfrosting/app/assets/package.json:
	docker exec -it -w /var/www/build $(NAME) npm run uf-assets-install

# Always recreate this
.PHONY: git/userfrosting/app/sprinkles.json
# TODO: Make this smart.
git/userfrosting/app/sprinkles.json:
	@/bin/cp -f git/userfrosting/app/sprinkles.example.json git/userfrosting/app/sprinkles.json

fixperms: git/userfrosting/app/.env
	@docker exec -it -w /var/www $(NAME) chown $(WEBUSER) app/logs app/cache app/sessions app/.env

git/userfrosting/app/.env:
	@touch git/userfrosting/app/.env
	docker exec -it -w /var/www $(NAME) php bakery bake

shell:
	docker exec -it $(NAME) bash

stop:
	@docker rm -f $(NAME) 2>/dev/null || :

stopall: stop-database stop

stop-database: load-passwords
	@/usr/bin/docker-compose -f docker-compose-database.yml -p uf rm -fsv 

start-prereq: docker-start-database

docker-start-database: load-passwords docker-compose
	@/usr/bin/docker-compose -f docker-compose-database.yml -p uf up -d

# We don't create the files as requirements, just in case something triggers
# a refresh. So we do it purely in bash.
load-passwords: generate-passwords
	$(eval MYSQLROOTPASSWORD = $(shell cat siteconfigs/mysqlrootpassword.txt))
	$(eval MYSQLUSERPASSWORD = $(shell cat siteconfigs/mysqluserpassword.txt))

generate-passwords:
	@mkdir -p siteconfigs
	@[ ! -e siteconfigs/mysqlrootpassword.txt ] && dd if=/dev/urandom bs=1k count=1 2>/dev/null | tr -dc 'a-zA-Z0-9' | cut -c-16 > siteconfigs/mysqlrootpassword.txt || :
	@[ ! -e siteconfigs/mysqluserpassword.txt ] && dd if=/dev/urandom bs=1k count=1 2>/dev/null | tr -dc 'a-zA-Z0-9' | cut -c-16 > siteconfigs/mysqluserpassword.txt || :

docker-compose: /usr/bin/docker-compose-$(COMPOSERVERSION)

/usr/bin/docker-compose-$(COMPOSERVERSION):
	yum -y remove docker-compose 2>/dev/null || :
	curl -L "https://github.com/docker/compose/releases/download/$(COMPOSERVERSION)/docker-compose-$(shell uname -s)-$(shell uname -m)" -o $@
	chmod 755 $@
	rm -f /usr/bin/docker-compose
	ln -s $@ /usr/bin/docker-compose

link-packages:
	@rm -rf image/packages
	@mkdir image/packages
	@ln packages/* image/packages

packages/%.tar.bz2: git/%/_GIT_UPDATE_
	mkdir -p packages
	cd git/$(*F) && tar --mtime="2019-01-01 01:01:01" --owner=0 --group=0 --numeric-owner --exclude-vcs --exclude='*.tgz' --exclude='node_modules' -jcf ../../$@ .

git/%/_GIT_UPDATE_: git/%/.git
	$(eval BRANCH = $($(shell echo $(*F) | tr '[:lower:]' '[:upper:]')_BRANCH))
	cd git/$* && git fetch && git -c advice.detachedHead=false checkout $(BRANCH) && git submodule update --recursive

git/%/_GIT_FORCE_UPDATE_: git/%/.git
	$(eval BRANCH = $($(shell echo $(*F) | tr '[:lower:]' '[:upper:]')_BRANCH))
	cd git/$* && git fetch && git -c advice.detachedHead=false checkout --force $(BRANCH) && git submodule update --recursive

# Hey make, don't try to delete this.
.PRECIOUS: git/%/.git
git/%/.git:
	$(eval REPO = $($(shell echo $(*F) | tr '[:lower:]' '[:upper:]')_REPO))
	mkdir -p git && git clone --recursive $(REPO) git/$(*F)


