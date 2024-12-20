<?php

use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DepartmentController;
use App\Http\Controllers\Api\EmployeeController;
use App\Http\Controllers\Api\PayrollController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public routes
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // Auth routes
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);

    // Department routes
    Route::apiResource('departments', DepartmentController::class);
    Route::get('departments/{department}/positions', [DepartmentController::class, 'positions']);

    // Employee routes
    Route::apiResource('employees', EmployeeController::class);
    Route::get('employees/{employee}/attendance-summary', [EmployeeController::class, 'getAttendanceSummary']);
    Route::get('employees/{employee}/salary-history', [EmployeeController::class, 'getSalaryHistory']);

    // Attendance routes
    Route::apiResource('attendance', AttendanceController::class);
    Route::post('attendance/bulk', [AttendanceController::class, 'bulkStore']);
    Route::get('attendance/summary', [AttendanceController::class, 'summary']);
    Route::get('attendance/daily-report', [AttendanceController::class, 'dailyReport']);

    // Payroll routes
    Route::apiResource('payroll', PayrollController::class);
    Route::post('payroll/generate', [PayrollController::class, 'generatePayroll']);
    Route::get('payroll/summary', [PayrollController::class, 'summary']);
    Route::post('payroll/{payroll}/process', [PayrollController::class, 'processPayroll']);
    Route::get('payroll/{payroll}/download', [PayrollController::class, 'downloadPayslip']);
    
    // Dashboard routes
    Route::get('dashboard/stats', [DashboardController::class, 'stats']);
    Route::get('dashboard/attendance-chart', [DashboardController::class, 'attendanceChart']);
    Route::get('dashboard/payroll-summary', [DashboardController::class, 'payrollSummary']);
});