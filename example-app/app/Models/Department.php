<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Department extends Model
{
    protected $fillable = ['name', 'code', 'description'];

    public function positions()
    {
        return $this->hasMany(Position::class);
    }
}