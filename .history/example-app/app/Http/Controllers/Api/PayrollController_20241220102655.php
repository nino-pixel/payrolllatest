<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\PayrollRequest;
use App\Models\Payroll;
use App\Models\Employee;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;

class PayrollController extends Controller
{
    public function index(Request $request)
    {
        $payrolls = Payroll::with(['employee', 'details'])
            ->when($request->employee_id, function($query) use ($request) {
                $query->where('employee_id', $request->employee_id);
            })
            ->when($request->status, function($query) use ($request) {
                $query->where('status', $request->status);
            })
            ->when($request->date_range, function($query) use ($request) {
                $dates = explode(',', $request->date_range);
                if (count($dates) === 2) {
                    $query->whereBetween('start_date', $dates);
                }
            })
            ->when($request->search, function($query) use ($request) {
                $query->where('payroll_id', 'like', "%{$request->search}%")
                    ->orWhereHas('employee', function($q) use ($request) {
                        $q->where('first_name', 'like', "%{$request->search}%")
                          ->orWhere('last_name', 'like', "%{$request->search}%");
                    });
            })
            ->orderBy($request->sort_by ?? 'created_at', $request->sort_order ?? 'desc')
            ->paginate($request->per_page ?? 10);

        return response()->json($payrolls);
    }

    public function store(PayrollRequest $request)
    {
        try {
            DB::beginTransaction();

            $validated = $request->validated();
            
            // Generate unique payroll ID
            $validated['payroll_id'] = 'PR-' . date('Ym') . '-' . str_pad(Payroll::count() + 1, 4, '0', STR_PAD_LEFT);

            // Get employee's base salary and calculate other amounts
            $employee = Employee::findOrFail($validated['employee_id']);
            $validated['base_salary'] = $employee->base_salary;
            
            // Calculate salaries
            $calculations = $this->calculatePayroll($employee, $validated);
            $payroll = Payroll::create(array_merge($validated, $calculations));

            // Create payroll details if provided
            if (isset($validated['details'])) {
                $payroll->details()->createMany($validated['details']);
            }

            DB::commit();
            return response()->json($payroll->load(['employee', 'details']), Response