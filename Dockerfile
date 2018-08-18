# Debian stretch-based container with app user and its home directory - /app
# It contains confd, git, vim, PHP and all PHP dependencies required to run Spryker

FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

# Setup application user
RUN  mkdir /app \
  && groupadd --system --gid 1000 app \
  && useradd --system --gid 1000 --uid 1000 --home-dir /app app

# Install pre-requirement packages
RUN  apt-get -qy update \
  && apt-get -y --no-install-recommends install wget apt-transport-https ca-certificates gnupg \
  && rm -rf /var/lib/apt/lists/*

# Install confd
RUN  wget -qO /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 \
  && chmod 755 /usr/local/bin/confd

# Setup package repositories, install packages
RUN  wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - \
  && echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list \
  && apt-get update \
  && apt-get -y --no-install-recommends install \
       git readline-common vim unzip \
       php7.1 php7.1-bcmath php7.1-bz2 php7.1-cli php7.1-fpm php7.1-curl php7.1-gd php7.1-gmp \
       php7.1-intl php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-pgsql php7.1-sqlite3 php7.1-xml \
       php7.1-opcache \
       php-igbinary php-imagick php-memcached php-msgpack php-redis php-ssh2 \
  && rm -rf /var/lib/apt/lists/*

# Home directory for container service
WORKDIR /app
