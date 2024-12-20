<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PayrollDetail;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class PayrollDetailController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'payroll_id' => 'required|exists:payrolls,id',
            'description' => 'required|string',
            'type' => 'required|in:earning,deduction',
            'amount' => 'required|numeric'
        ]);

        $detail = PayrollDetail::create($validated);
        return response()->json($detail, Response::HTTP_CREATED);
    }

    public function update(Request $request, PayrollDetail $detail)
    {
        $validated = $request->validate([
            'description' => 'required|string',
            'type' => 'required|in:earning,deduction',
            'amount' => 'required|numeric'
        ]);

        $detail->update($validated);
        return response()->json($detail);
    }

    public function destroy(PayrollDetail $detail)
    {
        $detail->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }
}