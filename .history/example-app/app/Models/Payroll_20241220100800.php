<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Payroll extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'employee_id',
        'payroll_id',
        'start_date',
        'end_date',
        'base_salary',
        'gross_salary',
        'total_deductions',
        'net_salary',
        'total_working_days',
        'days_worked',
        'overtime_hours',
        'overtime_pay',
        'allowances',
        'deductions',
        'status',
        'payment_date',
        'payment_method',
        'notes'
    ];

    protected $casts = [
        'start_date' => 'date',
        'end_date' => 'date',
        'payment_date' => 'date',
        'base_salary' => 'decimal:2',
        'gross_salary' => 'decimal:2',
        'total_deductions' => 'decimal:2',
        'net_salary' => 'decimal:2',
        'overtime_pay' => 'decimal:2',
        'allowances' => 'decimal:2',
        'deductions' => 'decimal:2'
    ];

    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }

    public function details()
    {
        return $this->hasMany(PayrollDetail::class);
    }
}