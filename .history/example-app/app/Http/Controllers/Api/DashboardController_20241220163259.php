<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Employee;
use App\Models\Attendance;
use App\Models\Payroll;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function stats()
    {
        return response()->json([
            'total_employees' => Employee::count(),
            'active_employees' => Employee::where('status', 'Active')->count(),
            'departments' => Employee::distinct('department')->count('department'),
        ]);
    }

    public function attendanceChart()
    {
        $attendance = Attendance::selectRaw('DATE(created_at) as date, COUNT(*) as count')
            ->groupBy('date')
            ->orderBy('date')
            ->get();

        return response()->json($attendance);
    }

    public function payrollSummary()
    {
        $payroll = Payroll::selectRaw('SUM(amount) as total, MONTH(created_at) as month')
            ->groupBy('month')
            ->orderBy('month')
            ->get();

        return response()->json($payroll);
    }
}