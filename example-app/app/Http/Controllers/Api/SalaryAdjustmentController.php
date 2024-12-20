<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\SalaryAdjustmentRequest;
use App\Models\SalaryAdjustment;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class SalaryAdjustmentController extends Controller
{
    public function index(Request $request)
    {
        $adjustments = SalaryAdjustment::with('employee')
            ->when($request->employee_id, function($query) use ($request) {
                $query->where('employee_id', $request->employee_id);
            })
            ->when($request->type, function($query) use ($request) {
                $query->where('type', $request->type);
            })
            ->when($request->is_active, function($query) {
                $query->where('is_active', true);
            })
            ->when($request->search, function($query) use ($request) {
                $query->where('description', 'like', "%{$request->search}%")
                    ->orWhereHas('employee', function($q) use ($request) {
                        $q->where('first_name', 'like', "%{$request->search}%")
                          ->orWhere('last_name', 'like', "%{$request->search}%");
                    });
            })
            ->orderBy($request->sort_by ?? 'effective_date', $request->sort_order ?? 'desc')
            ->paginate($request->per_page ?? 10);

        return response()->json($adjustments);
    }

    public function store(SalaryAdjustmentRequest $request)
    {
        $adjustment = SalaryAdjustment::create($request->validated());
        return response()->json($adjustment->load('employee'), Response::HTTP_CREATED);
    }

    public function show(SalaryAdjustment $adjustment)
    {
        return response()->json($adjustment->load('employee'));
    }

    public function update(SalaryAdjustmentRequest $request, SalaryAdjustment $adjustment)
    {
        $adjustment->update($request->validated());
        return response()->json($adjustment->load('employee'));
    }

    public function destroy(SalaryAdjustment $adjustment)
    {
        $adjustment->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }

    public function toggleStatus(SalaryAdjustment $adjustment)
    {
        $adjustment->update(['is_active' => !$adjustment->is_active]);
        return response()->json($adjustment->load('employee'));
    }
}