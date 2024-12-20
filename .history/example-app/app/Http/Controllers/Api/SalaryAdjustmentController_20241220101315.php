<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SalaryAdjustment;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class SalaryAdjustmentController extends Controller
{
    public function index(Request $request)
    {
        $adjustments = SalaryAdjustment::with('employee')
            ->when($request->employee_id, function($query) use ($request) {
                return $query->where('employee_id', $request->employee_id);
            })
            ->when($request->type, function($query) use ($request) {
                return $query->where('type', $request->type);
            })
            ->when($request->is_active, function($query) {
                return $query->where('is_active', true);
            })
            ->latest()
            ->get();

        return response()->json($adjustments);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'employee_id' => 'required|exists:employees,id',
            'type' => 'required|in:bonus,deduction,overtime,allowance,tax',
            'amount' => 'required|numeric|min:0',
            'effective_date' => 'required|date',
            'description' => 'required|string',
            'frequency' => 'required|in:one_time,recurring',
            'is_active' => 'boolean'
        ]);

        $adjustment = SalaryAdjustment::create($validated);
        return response()->json($adjustment->load('employee'), Response::HTTP_CREATED);
    }

    public function show(SalaryAdjustment $adjustment)
    {
        return response()->json($adjustment->load('employee'));
    }

    public function update(Request $request, SalaryAdjustment $adjustment)
    {
        $validated = $request->validate([
            'type' => 'required|in:bonus,deduction,overtime,allowance,tax',
            'amount' => 'required|numeric|min:0',
            'effective_date' => 'required|date',
            'description' => 'required|string',
            'frequency' => 'required|in:one_time,recurring',
            'is_active' => 'boolean'
        ]);

        $adjustment->update($validated);
        return response()->json($adjustment->load('employee'));
    }

    public function destroy(SalaryAdjustment $adjustment)
    {
        $adjustment->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }
}