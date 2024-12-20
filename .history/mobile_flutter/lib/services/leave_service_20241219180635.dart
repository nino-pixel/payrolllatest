enum LeaveType {
  vacation,
  sick,
  emergency,
  maternity,
  paternity
}

class LeaveRequest {
  final String employeeId;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // pending, approved, rejected
  final DateTime requestDate;

  LeaveRequest({
    required this.employeeId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = 'pending',
    DateTime? requestDate,
  }) : requestDate = requestDate ?? DateTime.now();
}

class LeaveService {
  static Future<void> submitLeaveRequest(LeaveRequest request) async {
    // TODO: Implement API call
    // For now, just simulate an API delay
    await Future.delayed(const Duration(seconds: 1));
  }

  static Map<LeaveType, int> getLeaveBalance() {
    // TODO: Get from API
    return {
      LeaveType.vacation: 10,
      LeaveType.sick: 8,
      LeaveType.emergency: 5,
      LeaveType.maternity: 60,
      LeaveType.paternity: 7,
    };
  }
}