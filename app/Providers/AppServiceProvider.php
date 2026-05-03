<?php

namespace App\Providers;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Handle lazy loading violations by logging a warning message.
        Model::handleLazyLoadingViolationUsing(function (Model $model, string $relation) {
            logger()->warning("Lazy loading violation: Attempted to lazy load [{$relation}] on model [" . get_class($model) . "].");
        });
    }
}
