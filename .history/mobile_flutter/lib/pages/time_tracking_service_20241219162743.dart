class TimeTrackingService {
  static bool _isClockedIn = false;
  static DateTime? _clockInTime;
  static DateTime? _clockOutTime;

  static bool get isClockedIn => _isClockedIn;
  static DateTime? get clockInTime => _clockInTime;
  static DateTime? get clockOutTime => _clockOutTime;

  static void clockIn() {
    _isClockedIn = true;
    _clockInTime = DateTime.now();
    _clockOutTime = null;
  }

  static void clockOut() {
    _isClockedIn = false;
    _clockOutTime = DateTime.now();
  }
}