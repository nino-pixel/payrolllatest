
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
  final String status;
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
  // Add this method
  static Future<void> submitLeaveRequest(LeaveRequest request) async {
    // TODO: Implement API call
    // For now, just simulate an API delay
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<List<LeaveRequest>> getLeaveHistory() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      LeaveRequest(
        employeeId: 'EMP001',
        type: LeaveType.vacation,
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        endDate: DateTime.now().subtract(const Duration(days: 10)),
        reason: 'Family vacation',
      ),
      LeaveRequest(
        employeeId: 'EMP001',
        type: LeaveType.sick,
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        endDate: DateTime.now().subtract(const Duration(days: 4)),
        reason: 'Fever',
      ),
    ];
  }

  static Map<LeaveType, int> getLeaveBalance() {
    return {
      LeaveType.vacation: 10,
      LeaveType.sick: 8,
      LeaveType.emergency: 5,
      LeaveType.maternity: 60,
      LeaveType.paternity: 7,
    };
  }
}