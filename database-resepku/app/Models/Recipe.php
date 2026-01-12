<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Recipe extends Model
{
    use HasFactory;
    
    protected $fillable = [
        'title',
        'description',
        'ingredients',
        'steps',
        'photo',
        'user_id'
    ];

    protected $casts = [
        'ingredients' => 'array',
        'steps' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
