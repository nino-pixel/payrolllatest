import 'package:flutter/material.dart';
import '../services/overtime_service.dart';

class OvertimeHistory extends StatelessWidget {
  const OvertimeHistory({super.key});

  String _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return '🟢';
      case 'rejected':
        return '🔴';
      default:
        return '🟡';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OvertimeRequest>>(
      future: OvertimeService.getOvertimeHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading overtime history: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No overtime history found'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final overtime = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      '${overtime.type.toString().split('.').last} Overtime',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusColor(overtime.status),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${overtime.date.day}/${overtime.date.month}/${overtime.date.year}',
                    ),
                    Text(
                      'Time: ${overtime.startTime.format(context)} - ${overtime.endTime.format(context)}',
                    ),
                    Text('Reason: ${overtime.reason}'),
                    Text(
                      'Status: ${overtime.status[0].toUpperCase()}${overtime.status.substring(1)}',
                      style: TextStyle(
                        color: overtime.status == 'approved'
                            ? Colors.green
                            : overtime.status == 'rejected'
                                ? Colors.red
                                : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Show detailed view if needed
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Overtime Details'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: ${overtime.type.toString().split('.').last}'),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${overtime.date.day}/${overtime.date.month}/${overtime.date.year}',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Time: ${overtime.startTime.format(context)} - ${overtime.endTime.format(context)}',
                          ),
                          const SizedBox(height: 8),
                          Text('Reason: ${overtime.reason}'),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${overtime.status[0].toUpperCase()}${overtime.status.substring(1)}',
                            style: TextStyle(
                              color: overtime.status == 'approved'
                                  ? Colors.green
                                  : overtime.status == 'rejected'
                                      ? Colors.red
                                      : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Requested on: ${overtime.requestDate.day}/${overtime.requestDate.month}/${overtime.requestDate.year}',
                          ),
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