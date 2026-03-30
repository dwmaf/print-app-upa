<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command('ngrok:start', function () {
    $url = config('app.url');
    // Ambil domain saja (hilangkan https://)
    $domain = parse_url($url, PHP_URL_HOST);

    // Cek apakah APP_URL diset ke localhost atau domain ngrok
    if (!$domain || $domain === 'localhost' || $domain === '127.0.0.1') {
        $this->info("APP_URL is localhost. Starting standard ngrok...");
        passthru("ngrok http 8000");
    } else {
        $this->info("Starting Ngrok for domain: $domain");
        passthru("ngrok http --url={$domain} 8000");
    }
})->purpose('Start Ngrok based on APP_URL from .env');