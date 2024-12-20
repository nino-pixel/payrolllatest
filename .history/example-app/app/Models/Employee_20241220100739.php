<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Employee extends Model
{
    use HasFactory, SoftDeletes;

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

    protected $casts = [
        'hire_date' => 'date',
        'base_salary' => 'decimal:2'
    ];

    public function department()
    {
        return $this->belongsTo(Department::class);
    }

    public function attendances()
    {
        return $this->hasMany(Attendance::class);
    }

    public function salaryAdjustments()
    {
        return $this->hasMany(SalaryAdjustment::class);
    }

    public function payrolls()
    {
        return $this->hasMany(Payroll::class);
    }

    public function getFullNameAttribute()
    {
        return "{$this->first_name} {$this->last_name}";
    }
}