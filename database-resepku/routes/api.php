<?php

use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\RecipeController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);

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

Route::get('/recipes', [RecipeController::class, 'index']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/recipes', [RecipeController::class, 'store']);
    Route::get('/recipes/my', [RecipeController::class, 'myRecipes']);
    Route::put('/recipes/{id}', [RecipeController::class, 'update']); 
    Route::delete('/recipes/{id}', [RecipeController::class, 'destroy']);
});

Route::get('/recipes/{id}', [RecipeController::class, 'show']);

Route::middleware('auth:sanctum')->delete(
    '/recipes/{id}/image', 
    [RecipeController::class, 'deletePhoto']
);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/favorites/{recipeId}', [FavoriteController::class, 'toggle']); 
    Route::get('/favorites', [FavoriteController::class, 'myFavorites']); 
});

Route::get('/ping', function () {
    return response()->json([
        'status' => 'success',
        'message' => 'API OK'
    ]);
});