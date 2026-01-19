<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Response;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/storage/recipes/{filename}', function ($filename) {
    $path = storage_path('app/public/recipes/' . $filename);

    if (!file_exists($path)) {
        abort(404);
    }

    $file = file_get_contents($path);
    $type = mime_content_type($path);

    $response = Response::make($file, 200);
    
    // Standard headers
    $response->header("Content-Type", $type);
    
    // THE FIX: Explicitly allow your Flutter app
    $response->header("Access-Control-Allow-Origin", "*"); 

    return $response;
});