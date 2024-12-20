<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class AttendanceController extends Controller
{
    public function index(Request $request)
    {
        $attendances = Attendance::with('employee')
            ->when($request->date, function($query) use ($request) {
                return $query->whereDate('date', $request->date);
            })
            ->when($request->employee_id, function($query) use ($request) {
                return $query->where('employee_id', $request->employee_id);
            })
            ->latest('date')
            ->get();
            
        return response()->json($attendances);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'employee_id' => 'required|exists:employees,id',
            'date' => 'required|date',
            'time_in' => 'required|date_format:H:i',
            'time_out' => 'nullable|date_format:H:i|after:time_in',
            'status' => 'required|in:present,absent,late,half_day,on_leave',
            'notes' => 'nullable|string'
        ]);

        // Check for existing attendance
        $exists = Attendance::where('employee_id', $validated['employee_id'])
            ->where('date', $validated['date'])
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'Attendance already exists for this date'
            ], Response::HTTP_CONFLICT);
        }

        $attendance = Attendance::create($validated);
        return response()->json($attendance->load('employee'), Response::HTTP_CREATED);
    }

    public function show(Attendance $attendance)
    {
        return response()->json($attendance->load('employee'));
    }

    public function update(Request $request, Attendance $attendance)
    {
        $validated = $request->validate([
            'time_in' => 'required|date_format:H:i',
            'time_out' => 'nullable|date_format:H:i|after:time_in',
            'status' => 'required|in:present,absent,late,half_day,on_leave',
            'notes' => 'nullable|string'
        ]);

        $attendance->update($validated);
        return response()->json($attendance->load('employee'));
    }

    public function destroy(Attendance $attendance)
    {
        $attendance->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }
}