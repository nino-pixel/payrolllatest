
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
  static Future<void> submitOvertimeRequest(OvertimeRequest request) async {
    // TODO: Implement API call
    // For now, just simulate an API delay
    await Future.delayed(const Duration(seconds: 1));
  }
}