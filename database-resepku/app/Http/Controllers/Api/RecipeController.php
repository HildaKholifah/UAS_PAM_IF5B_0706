<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Recipe;
use Illuminate\Http\Request;

class RecipeController extends Controller
{
    public function index()
    {
        $recipes = Recipe::with('user:id,name')
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar resep',
            'data' => $recipes
        ], 200);
    }
}
