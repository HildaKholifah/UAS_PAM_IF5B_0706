<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Recipe;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class RecipeController extends Controller
{
    public function index()
    {
        $recipes = Recipe::latest()->get();

        foreach ($recipes as $recipe) {
            $recipe->image_url = $recipe->image
                ? asset('storage/' . $recipe->image)
                : null;
        }

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
            'image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $imagePath = null;

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')
                ->store('recipes', 'public');
        }

        $recipe = Recipe::create([
            'title' => $request->title,
            'description' => $request->description,
            'ingredients' => $request->ingredients,
            'steps' => $request->steps,
            'image' => $imagePath,
            'user_id' => Auth::id(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Resep berhasil ditambahkan',
            'data' => $recipe
        ], 201);
    }

    public function myRecipes(Request $request)
    {
        $recipes = Recipe::where('user_id', $request->user()->id)
            ->latest()
            ->get();

        foreach ($recipes as $recipe) {
            $recipe->image_url = $recipe->image
                ? asset('storage/' . $recipe->image)
                : null;
        }

        return response()->json([
            'success' => true,
            'data' => $recipes
        ], 200);
    }

    public function show($id)
    {
        $recipe = Recipe::with('user:id,name')
            ->find($id);

        $recipe->image_url = $recipe->image
            ? asset('storage/' . $recipe->image)
            : null;

        if (!$recipe) {
            return response()->json([
                'success' => false,
                'message' => 'Resep tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail resep',
            'data' => $recipe
        ], 200);
    }

    public function update(Request $request, $id)
    {
        $recipe = Recipe::find($id);

        if (!$recipe) {
            return response()->json([
                'success' => false,
                'message' => 'Resep tidak ditemukan'
            ], 404);
        }

        if ($recipe->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak berhak mengedit resep ini'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'ingredients' => 'required|array|min:1',
            'steps' => 'required|array|min:1',
            'image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        // 🔄 Update data utama
        $recipe->title = $request->title;
        $recipe->description = $request->description;
        $recipe->ingredients = json_encode($request->ingredients);
        $recipe->steps = json_encode($request->steps);

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('recipes', 'public');
            $recipe->image = $imagePath;
        }

        // $recipe->update([
        //     'title' => $request->title,
        //     'description' => $request->description,
        //     'ingredients' => json_encode($request->ingredients),
        //     'steps' => json_encode($request->steps),
        // ]);

        $recipe->save();

        return response()->json([
            'success' => true,
            'message' => 'Resep berhasil diperbarui',
            'data' => $recipe
        ], 200);

        if ($request->hasFile('image')) {
        // hapus foto lama jika ada
            if ($recipe->image && Storage::disk('public')->exists($recipe->image)) {
                Storage::disk('public')->delete($recipe->image);
            }

            $recipe->image = $request->file('image')->store('recipes', 'public');
            $recipe->image = $imagePath;
        }

    }

    public function destroy($id)
    {
        $recipe = Recipe::find($id);

        if (!$recipe) {
            return response()->json([
                'success' => false,
                'message' => 'Resep tidak ditemukan'
            ], 404);
        }

        if ($recipe->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak berhak menghapus resep ini'
            ], 403);
        }

        if ($recipe->image && Storage::disk('public')->exists($recipe->image)) {
            Storage::disk('public')->delete($recipe->image);
        }

        $recipe->delete();

        return response()->json([
            'success' => true,
            'message' => 'Resep berhasil dihapus'
        ], 200);
    }

    public function deletePhoto($id)
    {
        $recipe = Recipe::find($id);

        if (!$recipe) {
            return response()->json([
                'success' => false,
                'message' => 'Resep tidak ditemukan'
            ], 404);
        }

        if ($recipe->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'Tidak diizinkan'
            ], 403);
        }

        if ($recipe->image && Storage::disk('public')->exists($recipe->image)) {
            Storage::disk('public')->delete($recipe->image);
            $recipe->image = null;
            $recipe->save();
        }

        return response()->json([
            'success' => true,
            'message' => 'Foto resep berhasil dihapus'
        ]);
    }

    // POST api/recipes/{id}/rate
public function rate(Request $request, $id)
{
    $request->validate([
        'rating' => 'required|integer|min:1|max:5'
    ]);

    $recipe = Recipe::find($id);
    if (!$recipe) {
        return response()->json([
            'success' => false,
            'message' => 'Resep tidak ditemukan'
        ], 404);
    }

    // Simpan rating user, misal di table recipe_ratings (user_id, recipe_id, rating)
    $recipe->ratings()->updateOrCreate(
        ['user_id' => $request->user()->id],
        ['rating' => $request->rating]
    );

    return response()->json([
        'success' => true,
        'message' => 'Rating berhasil disimpan'
    ], 200);
}

}
