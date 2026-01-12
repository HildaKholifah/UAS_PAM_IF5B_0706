<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Recipe;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class RecipeController extends Controller
{
    public function index()
    {
        $recipes = Recipe::latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar resep',
            'data' => $recipes
        ], 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'ingredients' => 'required|array|min:1',
            'steps' => 'required|array|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $recipe = Recipe::create([
            'title' => $request->title,
            'description' => $request->description,
            'ingredients' => json_encode($request->ingredients),
            'steps' => json_encode($request->steps),
            'user_id' => Auth::id(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Resep berhasil ditambahkan',
            'data' => $recipe
        ], 201);
    }
}
