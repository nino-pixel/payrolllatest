<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Attendance extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'employee_id',
        'date',
        'time_in',
        'time_out',
        'status',
        'notes'
    ];

    protected $casts = [
        'date' => 'date',
        'time_in' => 'datetime',
        'time_out' => 'datetime'
    ];

    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }
}