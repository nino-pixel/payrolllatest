<?php

use App\Http\Controllers\Api\DepartmentController;
use App\Http\Controllers\Api\EmployeeController;
use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\SalaryAdjustmentController;
use App\Http\Controllers\Api\PayrollController;
use App\Http\Controllers\Api\PayrollDetailController;
use Illuminate\Support\Facades\Route;

// Department routes
Route::apiResource('departments', DepartmentController::class);

// Employee routes
Route::apiResource('employees', EmployeeController::class);
Route::get('employees/{employee}/attendance-summary', [EmployeeController::class, 'getAttendanceSummary']);
Route::get('employees/{employee}/salary-history', [EmployeeController::class, 'getSalaryHistory']);

// Attendance routes
Route::apiResource('attendances', AttendanceController::class);
Route::post('attendances/bulk', [AttendanceController::class, 'bulkStore']);

// Salary Adjustment routes
Route::apiResource('salary-adjustments', SalaryAdjustmentController::class);
Route::patch('salary-adjustments/{adjustment}/toggle-status', [SalaryAdjustmentController::class, 'toggleStatus']);

// Payroll routes
Route::apiResource('payrolls', PayrollController::class);

// Payroll Detail routes (nested under payrolls)
Route::apiResource('payroll-details', PayrollDetailController::class)->except(['index', 'show']);


Route::post('auth/login', [AuthController::class, 'login']);
Route::post('auth/register', [AuthController::class, 'register']);


