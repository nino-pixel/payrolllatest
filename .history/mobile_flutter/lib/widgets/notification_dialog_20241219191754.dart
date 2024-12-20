import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/notification_service.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'leave':
        return Icons.event_available;
      case 'overtime':
        return Icons.access_time;
      case 'payroll':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'leave':
        return Colors.green;
      case 'overtime':
        return Colors.orange;
      case 'payroll':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF6B2C91),
              child: const Row(
                children: [
                  Icon(Icons.notifications, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<NotificationItem>>(
                future: NotificationService.getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No notifications'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final notification = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getNotificationColor(notification.type).withOpacity(0.1),
                          child: Icon(
                            _getNotificationIcon(notification.type),
                            color: _getNotificationColor(notification.type),
                          ),
                        ),
                        title: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification.message),
                            Text(
                              timeago.format(notification.timestamp),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await NotificationService.markAsRead(notification.id);
                          // Handle notification tap
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}