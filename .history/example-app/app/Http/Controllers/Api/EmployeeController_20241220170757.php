<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

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