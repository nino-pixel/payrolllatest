class AttendanceRecord {
  final String employeeId;
  final DateTime date;
  final DateTime timeIn;
  final DateTime? timeOut;
  final String status; // present, late, absent, etc.
  final String? notes;

  AttendanceRecord({
    required this.employeeId,
    required this.date,
    required this.timeIn,
    this.timeOut,
    required this.status,
    this.notes,
  });
}

class AttendanceService {
  static Future<List<AttendanceRecord>> getAttendanceHistory() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      AttendanceRecord(
        employeeId: 'EMP001',
        date: DateTime.now().subtract(const Duration(days: 1)),
        timeIn: DateTime.now().subtract(const Duration(days: 1, hours: 9)),
        timeOut: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        status: 'present',
      ),
      AttendanceRecord(
        employeeId: 'EMP001',
        date: DateTime.now().subtract(const Duration(days: 2)),
        timeIn: DateTime.now().subtract(const Duration(days: 2, hours: 8, minutes: 45)),
        timeOut: DateTime.now().subtract(const Duration(days: 2, hours: 0, minutes: 30)),
        status: 'late',
        notes: 'Traffic',
      ),
    ];
  }
}