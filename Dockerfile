# Use the official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install \
    intl \
    pdo \
    pdo_mysql \
    opcache \
    zip

# Enable Apache Rewrite Module
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy existing application directory contents
COPY . /var/www/html

# Update Symfony dependencies
RUN composer update

# Ensure proper permissions
#RUN chown -R www-data:www-data /var/www/html/var /var/www/html/public /var/www/html/vendor /var/www/html/config

COPY ./apache-config.conf /etc/apache2/sites-available/000-default.conf
# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
