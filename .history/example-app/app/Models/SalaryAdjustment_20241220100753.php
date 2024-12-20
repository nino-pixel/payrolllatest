<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class SalaryAdjustment extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'employee_id',
        'type',
        'amount',
        'effective_date',
        'description',
        'frequency',
        'is_active'
    ];

    protected $casts = [
        'effective_date' => 'date',
        'amount' => 'decimal:2',
        'is_active' => 'boolean'
    ];

    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }
}