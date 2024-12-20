<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Employee extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'employee_id',
        'first_name',
        'last_name',
        'email',
        'phone',
        'department_id',
        'base_salary',
        'hire_date',
        'status'
    ];

    public function department()
    {
        return $this->belongsTo(Department::class);
    }
}