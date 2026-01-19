<?php

use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\RecipeController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Response; // Added for image serving
use Illuminate\Support\Facades\File;     // Added for image serving

/*
|--------------------------------------------------------------------------
| Authentication Routes
|--------------------------------------------------------------------------
*/
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);

/*
|--------------------------------------------------------------------------
| User Profile Routes
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->get('/profile', function (Request $request) {
    return response()->json([
        'success' => true,
        'data' => $request->user()
    ]);
});

Route::middleware('auth:sanctum')->get('/me', function (Request $request) {
    return response()->json([
        'user' => $request->user()
    ]);
});

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return response()->json([
        'success' => true,
        'data' => $request->user()
    ]);
});

/*
|--------------------------------------------------------------------------
| Recipe Routes
|--------------------------------------------------------------------------
*/
Route::get('/recipes', [RecipeController::class, 'index']);
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/recipes/my', [RecipeController::class, 'myRecipes']); 
    
    Route::post('/recipes', [RecipeController::class, 'store']);
    Route::put('/recipes/{id}', [RecipeController::class, 'update']); 
    Route::delete('/recipes/{id}', [RecipeController::class, 'destroy']);
    Route::delete('/recipes/{id}/image', [RecipeController::class, 'deletePhoto']);
});
Route::get('/recipes/{id}', [RecipeController::class, 'show']);

/*
|--------------------------------------------------------------------------
| Favorite Routes
|--------------------------------------------------------------------------
*/
// Note: You had duplicate definitions for favorites, I cleaned them up into one group
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/favorites/{recipeId}/toggle', [FavoriteController::class, 'toggle']); 
    Route::post('/favorites/{recipeId}', [FavoriteController::class, 'toggle']); // Keeping both as you had both
    Route::get('/favorites', [FavoriteController::class, 'myFavorites']); 
});

/*
|--------------------------------------------------------------------------
| Utility Routes
|--------------------------------------------------------------------------
*/
Route::get('/ping', function () {
    return response()->json([
        'status' => 'success',
        'message' => 'API OK'
    ]);
});

/*
|--------------------------------------------------------------------------
| SPECIAL IMAGE FIX FOR FLUTTER WEB
|--------------------------------------------------------------------------
| This route forces images to go through Laravel so we can add CORS headers.
*/
Route::get('/recipe-image/{filename}', function ($filename) {
    // 1. Define the path to the file in storage (adjust 'recipes/' if your folder structure differs)
    $path = public_path('storage/recipes/' . $filename);

    // 2. Check if file exists
    if (!File::exists($path)) {
        return response()->json(['message' => 'Image not found'], 404);
    }

    // 3. Get file content and type
    $file = File::get($path);
    $type = File::mimeType($path);

    // 4. Return the response with manual CORS headers
    $response = Response::make($file, 200);
    $response->header("Content-Type", $type);
    $response->header("Access-Control-Allow-Origin", "*"); 

    return $response;
});