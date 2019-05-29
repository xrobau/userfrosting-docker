# Licenced under the MIT Licence
# Copyright 2019, Rob Thomas <xrobau@gmail.com>

HUB = hub.docker.com/xrobau
NAME = derp
BUILD ?= 01
UFPORT ?= 8086

SMTP_SERVER ?= mail.example.com
SMTP_USER ?= user@example.com
SMTP_PASSWORD ?= password

VERSION := $(shell date +%Y%m%d).$(BUILD)

SSHAGENT = -v $(shell readlink -f ${SSH_AUTH_SOCK}):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent
PARAMS = --name=$(NAME) -p $(UFPORT):80 $(SSHAGENT) -e DEVMODE=true --network=uf_default $(MOUNTS) $(ENVVARS)

MOUNTS = -v $(shell pwd)/git/userfrosting:/var/www -v $(shell pwd)/git/userfrosting/public:/var/www/html $(SMOUNTS) $(COMPOSERMOUNT)
SMOUNTS = $(foreach s,$(wildcard sprinkles/*),-v $(shell pwd)/$(s):/var/www/app/sprinkles/$(notdir $(s)))
COMPOSERMOUNT = -v $(HOME)/.composer:/root/.composer

ENVVARS = -e DB_DRIVER=mysql -e DB_HOST=ufdb -e DB_PORT=3306 -e DB_NAME=userfrosting -e DB_USER=userfrosting -e DB_PASSWORD=$(MYSQLUSERPASSWORD)

COMPOSERVERSION=1.23.1
WEBUSER=www-data
UNAME_S = $(shell uname -s)

# gtar is required on Macs
ifeq ($(UNAME_S),Linux)
  TAR=$(shell which tar)
endif
ifeq ($(UNAME_S),Darwin)
  TAR=/usr/local/bin/gtar
endif

# Pull UserFrosting from git and rebuild if the json changes
PACKAGES := packages/userfrosting.tar.bz2

USERFROSTING_REPO = git@github.com:userfrosting/UserFrosting.git
USERFROSTING_BRANCH = origin/master
USERFROSTING_MOUNT = /var/www/

SPRINKLES = core admin account

SPRINKLES_DIRS = $(shell find sprinkles -type d | grep -v ' ')
SPRINKLES_FILES = $(shell find sprinkles -type f -name '*')

.PHONY: all build run watch shell stop stopall stop-database start-prereq docker-start-database \
	load-passwords generate-passwords docker-compose link-packages fixperms gensprinkles \
	package-sprinkles

export

all: $(PACKAGES) build debug-run watch

build: composer node $(PACKAGES) package-sprinkles link-packages
	docker build -t $(NAME):$(VERSION) --rm image

# We need to require autoload AND slim, because slim doesn't get loaded the first
# time composer is run. This could be fixed by creating a better (one that contains
# the gd module) composer container but, just running it twice works.
composer: gensprinkles git/userfrosting/app/vendor/autoload.php git/userfrosting/app/vendor/slim

# Adding package.json as a dep means we'll rebuild everything when it changes
node: git/userfrosting/build/node_modules git/userfrosting/app/assets/package.json

debug-run: start-prereq stop
	docker run -it -d $(PARAMS) $(MOUNTS) $(NAME):$(VERSION)

watch: git/userfrosting/app/vendor/autoload.php git/userfrosting/build/node_modules fixperms
	docker logs -f $(NAME)

#
# Yes. This has to happen twice, because slim isn't installed the first time.
#
git/userfrosting/app/vendor/autoload.php: git/userfrosting/.git
	@docker run -it $(MOUNTS) -e COMPOSER_CACHE_DIR=/root/.composer -w /var/www --rm composer composer update --ignore-platform-reqs  || :
git/userfrosting/app/vendor/slim:
	@docker run -it $(MOUNTS) -e COMPOSER_CACHE_DIR=/root/.composer -w /var/www --rm composer composer update --ignore-platform-reqs  || :

# We tag the package.json as a dep, so if it's updated we'll rebuild the mode modules. Above,
# that is marked as a dependancy of THIS, but make is smart enough to figure out what we want
# to achieve.
git/userfrosting/build/node_modules: git/userfrosting/build/package.json
	@docker run -it $(MOUNTS) -w /var/www/build --rm node:lts-jessie npm install
	@touch $@

git/userfrosting/app/assets/package.json: git/userfrosting/.git
	@docker run -it $(MOUNTS) -w /var/www/build --rm node:lts-jessie npm run uf-assets-install
	@touch $@

gensprinkles: $(SPRINKLES_FILES) $(SPRINKLES_DIRS)
	@echo '{ "require": { }, "base": [' > /tmp/sprinkles.json.new
	@for s in $(SPRINKLES) $(foreach s,$(wildcard sprinkles/*),$(notdir $(s))); do echo -n \"$$s\",; done | sed 's/,$$/\n/' >> /tmp/sprinkles.json.new
	@echo ']}' >> /tmp/sprinkles.json.new
	@[ ! -e git/userfrosting/app/sprinkles.json ] && cp /tmp/sprinkles.json.new git/userfrosting/app/sprinkles.json || :
	@cmp --silent git/userfrosting/app/sprinkles.json /tmp/sprinkles.json.new || /bin/cp -f /tmp/sprinkles.json.new git/userfrosting/app/sprinkles.json
	@rm -f /tmp/sprinkles.json.new

package-sprinkles: gensprinkles packages/sprinkles.tar.bz2

packages/sprinkles.tar.bz2: $(TAR) $(SPRINKLES_FILES) $(SPRINKLES_DIRS) 
	@for s in $(foreach s,$(wildcard sprinkles/*),$(notdir $(s))); do \
		docker run -it --rm -w /var/www/app $(MOUNTS) php:7.3.5-apache-stretch find sprinkles/$$s -name '*.php' -exec php -l {} \;;  done
	@rm -f packages/sprinkles.tar.bz2
	@cd sprinkles && $(TAR) -jcf ../packages/sprinkles.tar.bz2 $(foreach s,$(wildcard sprinkles/*),$(notdir $(s)))

fixperms:
	@[ ! -e git/userfrosting/app/.env ] && echo -e 'SMTP_HOST=$(SMTP_HOST)\nSMTP_USER=$(SMTP_USER)\nSMTP_PASSWORD=$(SMTP_PASSWORD)\n' > git/userfrosting/app/.env || :
	@docker run --rm $(MOUNTS) -w /var/www $(NAME):$(VERSION) chown $(WEBUSER) app/logs app/cache app/sessions app/.env

shell:
	docker exec -it $(NAME) bash

mysql: load-passwords
	docker exec -it $(NAME) mysql -hcoredb -uuserfrosting -p$(MYSQLUSERPASSWORD) userfrosting

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
	@[ -e /usr/bin/yum ] && yum -y remove docker-compose 2>/dev/null || :
	curl -L "https://github.com/docker/compose/releases/download/$(COMPOSERVERSION)/docker-compose-$(shell uname -s)-$(shell uname -m)" -o $@
	chmod 755 $@
	rm -f /usr/bin/docker-compose
	ln -s $@ /usr/bin/docker-compose

link-packages:
	@rm -rf image/packages
	@mkdir image/packages
	@ln packages/* image/packages

packages/%.tar.bz2: $(TAR) git/%/_GIT_UPDATE_
	mkdir -p packages
	cd git/$(*F) && $(TAR) --mtime="2019-01-01 01:01:01" --owner=0 --group=0 --numeric-owner --exclude-vcs --exclude='*.tgz' --exclude='node_modules' -jcf ../../$@ .

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


# For the macs!
/usr/local/bin/gtar:
	@if [ "$(strip $(shell uname -s))" == "Darwin" ]; then \
		brew install gnu-tar; \
	else \
		ln -s /usr/bin/tar /usr/local/bin/gtar; \
	fi

