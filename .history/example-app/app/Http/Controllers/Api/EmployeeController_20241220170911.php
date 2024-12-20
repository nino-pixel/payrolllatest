<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\EmployeeRequest;
use App\Models\Employee;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class EmployeeController extends Controller
{
    public function __construct()
    {
    }
    public function index(Request $request)
    {
        $employees = Employee::with('department')
            ->when($request->search, function($query) use ($request) {
                $query->where(function($q) use ($request) {
                    $q->where('first_name', 'like', "%{$request->search}%")
                      ->orWhere('last_name', 'like', "%{$request->search}%")
                      ->orWhere('employee_id', 'like', "%{$request->search}%");
                });
            })
            ->when($request->department_id, function($query) use ($request) {
                $query->where('department_id', $request->department_id);
            })
            ->when($request->status, function($query) use ($request) {
                $query->where('status', $request->status);
            })
            ->orderBy($request->sort_by ?? 'first_name', $request->sort_order ?? 'asc')
            ->paginate($request->per_page ?? 10);

        return response()->json($employees);
    }

    public function store(EmployeeRequest $request)
    {
        $employee = Employee::create($request->validated());
        return response()->json($employee->load('department'), Response::HTTP_CREATED);
    }

    public function show(Employee $employee)
    {
        return response()->json($employee->load([
            'department',
            'attendances' => function($query) {
                $query->latest()->take(30);
            },
            'salaryAdjustments' => function($query) {
                $query->where('is_active', true);
            },
            'payrolls' => function($query) {
                $query->latest()->take(12);
            }
        ]));
    }

    public function update(EmployeeRequest $request, Employee $employee)
    {
        $employee->update($request->validated());
        return response()->json($employee->load('department'));
    }

    public function destroy(Employee $employee)
    {
        $employee->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }

    public function getAttendanceSummary(Employee $employee, Request $request)
    {
        $startDate = $request->start_date ?? now()->startOfMonth();
        $endDate = $request->end_date ?? now()->endOfMonth();

        $summary = $employee->attendances()
            ->whereBetween('date', [$startDate, $endDate])
            ->selectRaw('
                COUNT(*) as total_days,
                SUM(CASE WHEN status = "present" THEN 1 ELSE 0 END) as present_days,
                SUM(CASE WHEN status = "absent" THEN 1 ELSE 0 END) as absent_days,
                SUM(CASE WHEN status = "late" THEN 1 ELSE 0 END) as late_days,
                SUM(CASE WHEN status = "half_day" THEN 1 ELSE 0 END) as half_days,
                SUM(CASE WHEN status = "on_leave" THEN 1 ELSE 0 END) as leave_days
            ')
            ->first();

        return response()->json($summary);
    }

    public function getSalaryHistory(Employee $employee)
    {
        $history = $employee->payrolls()
            ->with('details')
            ->latest()
            ->take(12)
            ->get()
            ->map(function($payroll) {
                return [
                    'payroll_id' => $payroll->payroll_id,
                    'period' => $payroll->start_date->format('M Y'),
                    'gross_salary' => $payroll->gross_salary,
                    'net_salary' => $payroll->net_salary,
                    'status' => $payroll->status,
                    'payment_date' => $payroll->payment_date?->format('Y-m-d'),
                ];
            });

        return response()->json($history);
    };

    
class EmployeeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'employee_id' => 'required|string|unique:employees,employee_id,' . $this->employee?->id,
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|email|unique:employees,email,' . $this->employee?->id,
            'phone' => 'nullable|string|max:20',
            'department_id' => 'required|exists:departments,id',
            'base_salary' => 'required|numeric|min:0',
            'hire_date' => 'required|date',
            'status' => 'required|in:active,inactive,on_leave'
        ];
    }

    public function messages(): array
    {
        return [
            'employee_id.required' => 'Employee ID is required',
            'employee_id.unique' => 'This Employee ID is already taken',
            'first_name.required' => 'First name is required',
            'last_name.required' => 'Last name is required',
            'email.required' => 'Email is required',
            'email.email' => 'Please enter a valid email address',
            'email.unique' => 'This email is already registered',
            'department_id.required' => 'Department is required',
            'department_id.exists' => 'Selected department does not exist',
            'base_salary.required' => 'Base salary is required',
            'base_salary.numeric' => 'Base salary must be a number',
            'base_salary.min' => 'Base salary cannot be negative',
            'hire_date.required' => 'Hire date is required',
            'hire_date.date' => 'Please enter a valid date',
            'status.required' => 'Status is required',
            'status.in' => 'Invalid status selected'
        ];
    }
}