<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\DepartmentRequest;
use App\Models\Department;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class DepartmentController extends Controller
{
    public function index(Request $request)
    {
        $departments = Department::with('positions')
            ->when($request->search, function($query) use ($request) {
                $query->where('name', 'like', "%{$request->search}%")
                    ->orWhere('code', 'like', "%{$request->search}%");
            })
            ->orderBy($request->sort_by ?? 'name', $request->sort_order ?? 'asc')
            ->paginate($request->per_page ?? 10);

        return response()->json($departments);
    }

    public function positions($id)
    {
        $department = Department::findOrFail($id);
        return response()->json($department->positions);
    }

    public function store(DepartmentRequest $request)
    {
        $department = Department::create($request->validated());
        return response()->json($department, Response::HTTP_CREATED);
    }

    public function show(Department $department)
    {
        return response()->json($department->load([
            'employees' => function($query) {
                $query->where('status', 'active');
            }
        ]));
    }

    public function update(DepartmentRequest $request, Department $department)
    {
        $department->update($request->validated());
        return response()->json($department);
    }

    public function destroy(Department $department)
    {
        $department->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }
}