<?php

use Illuminate\Support\Facades\DB;

test('Database connection is working', function () {
    $result = DB::select('SELECT 1 as connected');

    expect($result[0]->connected)->toBe(1);
});

test('Database is testing db', function () {
    $database = DB::select('SELECT current_database() as name');

    expect($database[0]->name)->toBe('laravel_test');
});
