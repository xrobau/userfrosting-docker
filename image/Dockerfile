FROM php:7.3.5-apache-stretch
LABEL maintainer="Rob Thomas <xrobau@linux.com>"

RUN apt-get update && apt-get -y install gnupg && curl https://packages.blackfire.io/gpg.key | apt-key add - && \
  echo "deb http://packages.blackfire.io/debian any main" > /etc/apt/sources.list.d/blackfire.list && \
  apt-get update && \
  apt-get --no-install-recommends -y install libbz2-dev libxslt1-dev git mariadb-client blackfire-agent \
        libmemcached-dev zlib1g-dev vim ctags vim-scripts blackfire-php cron mongodb \
        mongodb-server mongodb-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
        libcurl4-openssl-dev libedit-dev libxml2-dev libzip-dev libbz2-dev wget && \
  docker-php-ext-enable opcache.so && \
  wget -O /usr/bin/phpunit https://phar.phpunit.de/phpunit-6.phar && \
  chmod +x /usr/bin/phpunit && \
  pecl install memcached mongodb && \
  docker-php-ext-enable memcached mongodb && \
  docker-php-ext-install -j$(nproc) bcmath bz2 json mbstring pdo pdo_mysql xsl zip pcntl gd mysqli curl gettext hash posix readline simplexml zip && \
  curl -L -O https://github.com/tideways/php-xhprof-extension/archive/v5.0-beta1.tar.gz && \
  tar vxfz v5.0-beta1.tar.gz && cd php-xhprof-extension-5.0-beta1 && \
  phpize && ./configure && make -j$(nproc) && make install && \
  cd .. && rm -rf v5.0* php-xhprof* && \
  echo "extension=tideways_xhprof.so" > /usr/local/etc/php/conf.d/xhprof.ini && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && apt-get install -y nodejs zip unzip && \
  apt-get -y purge $(dpkg -l | awk '/lib.*-dev/ { print $2 }') && \
  rm -rf /var/lib/apt/lists/*

COPY blackfire.ini /root/.blackfire.ini
COPY block-badfiles.conf /etc/apache2/conf-enabled/
COPY 000-default.conf /etc/apache2/sites-enabled

# Composer
RUN curl https://getcomposer.org/installer | php -- --filename='composer' --install-dir='/usr/bin'

# Apache config
RUN a2enmod rewrite

# Debugging assistance inside container. Remove later.
RUN git clone https://github.com/xrobau/vim /root/.vim
COPY vimrc /etc/vim/vimrc
WORKDIR /var/www

ADD packages/userfrosting.tar.bz2 /var/www/
ADD packages/sprinkles.tar.bz2 /var/www/app/sprinkles/


