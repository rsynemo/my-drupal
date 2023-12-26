FROM php:8.2-fpm-alpine

# 更新软件包并安装必要依赖
RUN apk update && apk add --no-cache \
    autoconf \
    gcc \
    g++ \
    make \
    openssl \
    bash \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    freetype \
    freetype-dev \
    icu \
    icu-dev \
    libxml2 \
    libxml2-dev \
    zip \
    libzip \
    libzip-dev \
    git \
    curl \
    linux-headers # 添加这行来安装 linux-headers

# 安装和配置 PHP 扩展
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install intl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && docker-php-ext-install xml \
    && docker-php-ext-install zip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# 安装 Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 复制 Xdebug 配置
COPY xdebug.ini /usr/local/etc/php/conf.d/

# 设置工作目录
WORKDIR /var/www/html

# 复制入口点脚本并设置权限
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]

# 暴露端口
EXPOSE 9000
