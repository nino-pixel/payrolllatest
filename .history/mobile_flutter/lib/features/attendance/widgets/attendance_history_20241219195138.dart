import 'package:flutter/material.dart';
import '../../../data/services/attendance_service.dart';
import 'package:intl/intl.dart';

class AttendanceHistory extends StatelessWidget {
  const AttendanceHistory({super.key});

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AttendanceRecord>>(
      future: AttendanceService.getAttendanceHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading attendance history: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No attendance history found'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final record = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(record.date),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(record.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(record.status),
                        ),
                      ),
                      child: Text(
                        record.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(record.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Time In: ${_formatDateTime(record.timeIn)}'),
                    if (record.timeOut != null)
                      Text('Time Out: ${_formatDateTime(record.timeOut!)}'),
                    if (record.notes != null) Text('Notes: ${record.notes}'),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Attendance Details'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${DateFormat('MMMM dd, yyyy').format(record.date)}'),
                          const SizedBox(height: 8),
                          Text('Time In: ${_formatDateTime(record.timeIn)}'),
                          if (record.timeOut != null)
                            Text('Time Out: ${_formatDateTime(record.timeOut!)}'),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${record.status.toUpperCase()}',
                            style: TextStyle(
                              color: _getStatusColor(record.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (record.notes != null) ...[
                            const SizedBox(height: 8),
                            Text('Notes: ${record.notes}'),
                          ],
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}