<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payroll;
use App\Models\Employee;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class PayrollController extends Controller
{
    public function index(Request $request)
    {
        $payrolls = Payroll::with(['employee', 'details'])
            ->when($request->employee_id, function($query) use ($request) {
                return $query->where('employee_id', $request->employee_id);
            })
            ->when($request->status, function($query) use ($request) {
                return $query->where('status', $request->status);
            })
            ->latest()
            ->get();

        return response()->json($payrolls);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'employee_id' => 'required|exists:employees,id',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after:start_date',
            'total_working_days' => 'required|integer|min:0',
            'days_worked' => 'required|integer|min:0',
            'overtime_hours' => 'integer|min:0',
            'status' => 'required|in:draft,pending,approved,paid',
            'payment_method' => 'nullable|string',
            'notes' => 'nullable|string'
        ]);

        // Generate unique payroll ID
        $validated['payroll_id'] = 'PR-' . date('Ym') . '-' . str_pad(Payroll::count() + 1, 4, '0', STR_PAD_LEFT);

        // Get employee's base salary and calculate other amounts
        $employee = Employee::findOrFail($validated['employee_id']);
        $validated['base_salary'] = $employee->base_salary;
        
        // Basic calculations (you might want to move this to a service class)
        $validated['gross_salary'] = $this->calculateGrossSalary($employee, $validated);
        $validated['total_deductions'] = $this->calculateDeductions($employee, $validated);
        $validated['net_salary'] = $validated['gross_salary'] - $validated['total_deductions'];

        $payroll = Payroll::create($validated);

        // Create payroll details
        if ($request->has('details')) {
            $payroll->details()->createMany($request->details);
        }

        return response()->json($payroll->load(['employee', 'details']), Response::HTTP_CREATED);
    }

    public function show(Payroll $payroll)
    {
        return response()->json($payroll->load(['employee', 'details']));
    }

    public function update(Request $request, Payroll $payroll)
    {
        $validated = $request->validate([
            'status' => 'required|in:draft,pending,approved,paid',
            'payment_date' => 'nullable|date',
            'payment_method' => 'nullable|string',
            'notes' => 'nullable|string'
        ]);

        $payroll->update($validated);
        return response()->json($payroll->load(['employee', 'details']));
    }

    public function destroy(Payroll $payroll)
    {
        $payroll->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }

    private function calculateGrossSalary($employee, $data)
    {
        // Basic calculation (you should implement your own logic)
        $dailyRate = $employee->base_salary / $data['total_working_days'];
        $basicPay = $dailyRate * $data['days_worked'];
        $overtimePay = ($data['overtime_hours'] ?? 0) * ($dailyRate / 8 * 1.25); // Assuming 8-hour workday and 1.25x OT rate
        
        return $basicPay + $overtimePay;
    }

    private function calculateDeductions($employee, $data)
    {
        // Implement your deduction logic here
        // This might include tax, insurance, loans, etc.
        return 0; // Placeholder
    }
}