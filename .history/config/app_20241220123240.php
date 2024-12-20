<?php

return [
    'name' => env('APP_NAME', 'Laravel'),
    
    'env' => env('APP_ENV', 'production'),
    
    'debug' => (bool) env('APP_DEBUG', false),
    
    'url' => env('APP_URL', 'http://localhost'),
    
    // ... other configs ...

    'providers' => [
        /*
         * Laravel Framework Service Providers...
         */
        Illuminate\Auth\AuthServiceProvider::class,
        // ... other providers ...
        
        /*
         * Package Service Providers...
         */
        Laravel\Sanctum\SanctumServiceProvider::class,
        
        /*
         * Application Service Providers...
         */
        App\Providers\AppServiceProvider::class,
        App\Providers\AuthServiceProvider::class,
        // ... other providers ...
    ],
    
    // ... rest of config
]; 