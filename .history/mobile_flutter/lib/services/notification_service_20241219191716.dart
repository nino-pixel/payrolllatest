class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type; // 'leave', 'overtime', 'payroll', etc.

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });
}

class NotificationService {
  static Future<List<NotificationItem>> getNotifications() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      NotificationItem(
        id: '1',
        title: 'Leave Request Approved',
        message: 'Your leave request for May 15-16 has been approved.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'leave',
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'New Payslip Available',
        message: 'Your payslip for April 2024 is now available.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: 'payroll',
        isRead: true,
      ),
      NotificationItem(
        id: '3',
        title: 'Overtime Request Pending',
        message: 'Your overtime request for May 10 is pending approval.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: 'overtime',
        isRead: true,
      ),
    ];
  }

  static Future<void> markAsRead(String id) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(milliseconds: 500));
  }
}