#!/bin/bash
set -e

main() {
    if [ "$IS_WORKER" = "true" ]; then
        exec "$@"
    else
        prepare_file_permissions
        prepare_storage
        wait_for_db
        run_migrations
        optimize_app
        run_server "$@"
    fi
}

prepare_file_permissions() {
    chmod a+x ./artisan
}

prepare_storage() {
    mkdir -p /var/www/html/storage/framework/cache/data
    mkdir -p /var/www/html/storage/framework/sessions
    mkdir -p /var/www/html/storage/framework/views

    chown -R www-data:www-data /var/www/html/storage
    chmod -R 775 /var/www/html/storage

    php artisan storage:link --force
}

wait_for_db() {
    echo "Waiting for DB to be ready..."
    until pg_isready -h "$DB_HOST" -p "${DB_PORT:-5432}" -U "$DB_USERNAME" > /dev/null 2>&1; do
        sleep 1
    done
    echo "DB is ready."
}

run_migrations() {
    ./artisan migrate --force
}

optimize_app() {
    ./artisan optimize:clear
    ./artisan optimize
}

run_server() {
    exec /usr/local/bin/docker-php-entrypoint "$@"
}

main "$@"
