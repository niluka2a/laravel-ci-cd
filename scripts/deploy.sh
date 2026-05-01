#!/bin/bash
set -e

cd /var/www/laravel
git pull origin main
composer install --no-dev --no-progress --prefer-dist
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
sudo systemctl restart php8.5-fpm
