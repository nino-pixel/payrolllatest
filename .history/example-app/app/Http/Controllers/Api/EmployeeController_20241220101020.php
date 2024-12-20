<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Employee;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class EmployeeController extends Controller
{
    public function index()
    {
        $employees = Employee::with('department')
            ->orderBy('first_name')
            ->get();
        return response()->json($employees);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'employee_id' => 'required|string|unique:employees,employee_id',
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|email|unique:employees,email',
            'phone' => 'nullable|string|max:20',
            'department_id' => 'required|exists:departments,id',
            'base_salary' => 'required|numeric|min:0',
            'hire_date' => 'required|date',
            'status' => 'required|in:active,inactive,on_leave'
        ]);

        $employee = Employee::create($validated);
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
            }
        ]));
    }

    public function update(Request $request, Employee $employee)
    {
        $validated = $request->validate([
            'employee_id' => 'required|string|unique:employees,employee_id,' . $employee->id,
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|email|unique:employees,email,' . $employee->id,
            'phone' => 'nullable|string|max:20',
            'department_id' => 'required|exists:departments,id',
            'base_salary' => 'required|numeric|min:0',
            'hire_date' => 'required|date',
            'status' => 'required|in:active,inactive,on_leave'
        ]);

        $employee->update($validated);
        return response()->json($employee->load('department'));
    }

    public function destroy(Employee $employee)
    {
        $employee->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }
}