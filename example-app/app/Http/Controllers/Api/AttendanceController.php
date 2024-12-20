<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\AttendanceRequest;
use App\Models\Attendance;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class AttendanceController extends Controller
{
    public function index(Request $request)
    {
        $attendances = Attendance::with('employee')
            ->when($request->date, function($query) use ($request) {
                $query->whereDate('date', $request->date);
            })
            ->when($request->employee_id, function($query) use ($request) {
                $query->where('employee_id', $request->employee_id);
            })
            ->when($request->status, function($query) use ($request) {
                $query->where('status', $request->status);
            })
            ->when($request->search, function($query) use ($request) {
                $query->whereHas('employee', function($q) use ($request) {
                    $q->where('first_name', 'like', "%{$request->search}%")
                      ->orWhere('last_name', 'like', "%{$request->search}%");
                });
            })
            ->orderBy($request->sort_by ?? 'date', $request->sort_order ?? 'desc')
            ->paginate($request->per_page ?? 10);
            
        return response()->json($attendances);
    }

    public function store(AttendanceRequest $request)
    {
        // Check for existing attendance
        $exists = Attendance::where('employee_id', $request->employee_id)
            ->where('date', $request->date)
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'Attendance already exists for this date'
            ], Response::HTTP_CONFLICT);
        }

        $attendance = Attendance::create($request->validated());
        return response()->json($attendance->load('employee'), Response::HTTP_CREATED);
    }

    public function show(Attendance $attendance)
    {
        return response()->json($attendance->load('employee'));
    }

    public function update(AttendanceRequest $request, Attendance $attendance)
    {
        $attendance->update($request->validated());
        return response()->json($attendance->load('employee'));
    }

    public function destroy(Attendance $attendance)
    {
        $attendance->delete();
        return response()->json(null, Response::HTTP_NO_CONTENT);
    }

    public function bulkStore(Request $request)
    {
        $request->validate([
            'attendances' => 'required|array',
            'attendances.*.employee_id' => 'required|exists:employees,id',
            'attendances.*.date' => 'required|date',
            'attendances.*.time_in' => 'required|date_format:H:i',
            'attendances.*.time_out' => 'nullable|date_format:H:i|after:attendances.*.time_in',
            'attendances.*.status' => 'required|in:present,absent,late,half_day,on_leave',
            'attendances.*.notes' => 'nullable|string'
        ]);

        $created = collect($request->attendances)->map(function($attendance) {
            return Attendance::create($attendance);
        });

        return response()->json($created->load('employee'), Response::HTTP_CREATED);
    }
}