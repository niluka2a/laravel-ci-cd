#!/bin/bash
echo "Starting staging deployment..."

set -e

cd /var/www/laravel-staging

echo "[1/6] Pulling latest changes from Git..."
git pull origin develop

echo "[2/6] Installing dependencies..."
composer install --no-dev --no-progress --prefer-dist

echo "[3/6] Running migrations..."
php artisan migrate --force

echo "[4/6] Caching configuration..."
php artisan config:cache

echo "[5/6] Caching routes..."
php artisan route:cache

echo "[6/6] Caching views..."
php artisan view:cache

echo "Restarting PHP-FPM..."
sudo systemctl restart php8.5-fpm

echo "Staging deployment completed successfully!"
