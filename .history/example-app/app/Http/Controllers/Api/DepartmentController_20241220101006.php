<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Department;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class DepartmentController extends Controller
{
    public function index()
    {
        $departments = Department::withCount('employees')->get();
        return response()->json($departments);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'code' => 'required|string|unique:departments,code|max:50',
            'description' => 'nullable|string'
        ]);

        $department = Department::create($validated);
        return response()->json($department, Response::HTTP_CREATED);
    }

    public function show(Department $department)
    {
        return response()->json($department->load('employees'));
    }

    public function update(Request $request, Department $department)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'code' => 'required|string|unique:departments,code,' . $department->id . '|max:50',
            'description' => 'nullable|string'
        ]);

        $department->update($validated);
        return response()->json($department);
    }

    public function destroy(Department $department)
    {
        $department->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }
}