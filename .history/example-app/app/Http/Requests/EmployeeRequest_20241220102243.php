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
}