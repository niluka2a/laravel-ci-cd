#!/bin/bash
set -e
set -o pipefail

echo "Starting deployment..."

cd /var/www/laravel-staging

echo "[1/7] Pulling latest changes..."
git fetch origin develop
git reset --hard origin/develop

echo "[2/7] Installing dependencies..."
composer install --no-dev --no-progress --prefer-dist --no-interaction --optimize-autoloader

echo "[3/7] Running migrations..."
php artisan migrate --force

echo "[4/7] Clearing old caches..."
php artisan optimize:clear

echo "[5/7] Rebuilding caches..."
php artisan optimize

echo "[6/7] Restarting queue workers..."
php artisan queue:restart

echo "[7/7] Reloading PHP-FPM..."
sudo systemctl reload php8.4-fpm

echo "Deployment completed successfully!"