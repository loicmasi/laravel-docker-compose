FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    gnupg2 \
    libxml2-dev \
    libpq-dev \
    libssl-dev \
    libpng-dev \
    libzip-dev \
    nano \
    zip \
    unzip

# Install SQL Server drivers
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev && \
    pecl install sqlsrv pdo_sqlsrv && \
    docker-php-ext-enable sqlsrv pdo_sqlsrv

# Other PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Copy application source code to the container
COPY . /var/www/app

# Set working directory
WORKDIR /var/www/app

# Set file ownership
RUN chown -R www-data:www-data /var/www/app

# Expose the necessary port
EXPOSE 9000
