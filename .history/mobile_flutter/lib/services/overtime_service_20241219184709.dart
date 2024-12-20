import 'package:flutter/material.dart' show TimeOfDay;

enum OvertimeType {
  regular,
  holiday,
  restDay,
  nightShift
}

class OvertimeRequest {
  final String employeeId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final OvertimeType type;
  final String reason;
  final String status; // pending, approved, rejected
  final DateTime requestDate;

  OvertimeRequest({
    required this.employeeId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.reason,
    this.status = 'pending',
    DateTime? requestDate,
  }) : requestDate = requestDate ?? DateTime.now();
}

class OvertimeService {
  // Add this method
  static Future<void> submitOvertimeRequest(OvertimeRequest request) async {
    // TODO: Implement API call
    // For now, just simulate an API delay
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<List<OvertimeRequest>> getOvertimeHistory() async {
    // TODO: Implement API call
    // For now, return dummy data
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      OvertimeRequest(
        employeeId: 'EMP001',
        date: DateTime.now().subtract(const Duration(days: 5)),
        startTime: const TimeOfDay(hour: 17, minute: 0),
        endTime: const TimeOfDay(hour: 20, minute: 0),
        type: OvertimeType.regular,
        reason: 'Project deadline',
        status: 'approved',
      ),
      OvertimeRequest(
        employeeId: 'EMP001',
        date: DateTime.now().subtract(const Duration(days: 10)),
        startTime: const TimeOfDay(hour: 18, minute: 0),
        endTime: const TimeOfDay(hour: 21, minute: 0),
        type: OvertimeType.holiday,
        reason: 'System maintenance',
        status: 'rejected',
      ),
    ];
  }
}