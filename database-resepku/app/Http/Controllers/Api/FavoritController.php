<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Recipe;
use Illuminate\Support\Facades\Auth;

class FavoriteController extends Controller
{
    // Toggle favorit: jika sudah ada hapus, jika belum tambahkan
    public function toggle($recipeId)
    {
        $user = Auth::user();
        $recipe = Recipe::find($recipeId);

        if (!$recipe) {
            return response()->json([
                'success' => false,
                'message' => 'Resep tidak ditemukan'
            ], 404);
        }

        $exists = $user->favorites()->where('recipe_id', $recipeId)->exists();

        if ($exists) {
            $user->favorites()->detach($recipeId);
            return response()->json([
                'success' => true,
                'message' => 'Resep dihapus dari favorit'
            ]);
        } else {
            $user->favorites()->attach($recipeId);
            return response()->json([
                'success' => true,
                'message' => 'Resep ditambahkan ke favorit'
            ]);
        }
    }

    // Ambil resep favorit user
    public function myFavorites()
    {
        $user = Auth::user();
        $favorites = $user->favorites()->with('user')->get();

        foreach ($favorites as $recipe) {
            $recipe->image_url = $recipe->image
                ? asset('storage/' . $recipe->image)
                : null;
        }

        return response()->json([
            'success' => true,
            'data' => $favorites
        ]);
    }
}
