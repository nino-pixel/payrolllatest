import 'package:flutter/material.dart';
import '../../../data/services/leave_service.dart';

class LeaveHistory extends StatelessWidget {
  const LeaveHistory({super.key});

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
    return FutureBuilder<List<LeaveRequest>>(
      future: LeaveService.getLeaveHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading leave history: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No leave history found'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final leave = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      '${leave.type.toString().split('.').last} Leave',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusColor(leave.status),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${leave.startDate.day}/${leave.startDate.month}/${leave.startDate.year} - ${leave.endDate.day}/${leave.endDate.month}/${leave.endDate.year}',
                    ),
                    Text('Reason: ${leave.reason}'),
                    Text(
                      'Status: ${leave.status[0].toUpperCase()}${leave.status.substring(1)}',
                      style: TextStyle(
                        color: leave.status == 'approved'
                            ? Colors.green
                            : leave.status == 'rejected'
                                ? Colors.red
                                : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Leave Details'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: ${leave.type.toString().split('.').last}'),
                          const SizedBox(height: 8),
                          Text(
                            'Start Date: ${leave.startDate.day}/${leave.startDate.month}/${leave.startDate.year}',
                          ),
                          Text(
                            'End Date: ${leave.endDate.day}/${leave.endDate.month}/${leave.endDate.year}',
                          ),
                          const SizedBox(height: 8),
                          Text('Reason: ${leave.reason}'),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${leave.status[0].toUpperCase()}${leave.status.substring(1)}',
                            style: TextStyle(
                              color: leave.status == 'approved'
                                  ? Colors.green
                                  : leave.status == 'rejected'
                                      ? Colors.red
                                      : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Requested on: ${leave.requestDate.day}/${leave.requestDate.month}/${leave.requestDate.year}',
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