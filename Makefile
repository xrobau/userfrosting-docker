HUB = hub.docker.com/xrobau
NAME = derp
BUILD ?= 01
UFPORT = 8086

VERSION := $(shell date +%Y%m%d).$(BUILD)

PARAMS = --name=$(NAME) -p $(UFPORT):80 $(SSHAGENT) -e DEVMODE=true --network=uf_default -v $(shell pwd)/git/userfrosting:/var/www

COMPOSERVERSION=1.23.1

# Pull UserFrosting from git
PACKAGES := packages/userfrosting.tar.bz2

# Note that 'make nuke' does a 'git checkout --force' of these repositories.
# Don't use it unless you really need to.
USERFROSTING_REPO = git@github.com:userfrosting/UserFrosting.git
USERFROSTING_BRANCH = origin/master
USERFROSTING_MOUNT = /var/www/

.PHONY: build run stop start-prereq docker-start-database generate-passwords docker-compose link-packages

export

all: build run watch

build: $(PACKAGES) link-packages
	docker build -t $(NAME):$(VERSION) --rm image

run: start-prereq stop
	docker run -it -d $(PARAMS) $(NAME):$(VERSION)

watch:
	docker logs -f $(NAME)

shell:
	docker exec -it $(NAME) bash

stop:
	@docker rm -f $(NAME) 2>/dev/null || :

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


