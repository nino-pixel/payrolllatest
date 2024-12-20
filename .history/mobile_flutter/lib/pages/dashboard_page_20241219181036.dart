import 'package:flutter/material.dart';
import '../services/time_tracking_service.dart';
import 'dart:async';
import '../services/pdf_service.dart';
import '../services/payroll_service.dart';
import '../widgets/leave_request_dialog.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // List of pages/tabs
  final List<Widget> _pages = [
    const HomeTab(),
    const AttendanceTab(),
    const PayrollTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B2C91),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6B2C91),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payroll',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home Tab
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B2C91), Color(0xFF4A1F64)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Actions Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [// In HomeTab's _buildQuickActionCard for Clock In/Out
_buildQuickActionCard(
  icon: Icons.access_time,
  title: TimeTrackingService.isClockedIn ? 'Clock Out' : 'Clock In',
  onTap: () {
    if (TimeTrackingService.isClockedIn) {
      TimeTrackingService.clockOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully clocked out!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      TimeTrackingService.clockIn();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully clocked in!'),
          backgroundColor: Colors.green,
        ),
      );
    }
    // Force rebuild to update the UI
    (context as Element).markNeedsBuild();
  },
),
              // Inside HomeTab class
_buildQuickActionCard(
  icon: Icons.description,
  title: 'Latest Payslip',
  onTap: () async {
    try {
      final payslipData = PayrollService.getLatestPayslip();
      await PayslipPdfService.generatePayslip(
        employeeName: payslipData.employeeName,
        employeeId: payslipData.employeeId,
        period: payslipData.period,
        earnings: payslipData.earnings,
        deductions: payslipData.deductions,
        grossPay: payslipData.grossPay,
        netPay: payslipData.netPay,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Latest payslip downloaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating payslip: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  },
),
          
              // Inside HomeTab class, update the QuickActionCard for Request Leave
_buildQuickActionCard(
  icon: Icons.calendar_today,
  title: 'Request Leave',
  onTap: () async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const LeaveRequestDialog(),
    );
    
    if (result == true && context.mounted) {
      // Refresh the page or update leave balance if needed
    }
  },
),
              _buildQuickActionCard(
                icon: Icons.schedule,
                title: 'Overtime',
                onTap: () {
                  // TODO: Open overtime form
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: const Color(0xFF6B2C91),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// After HomeTab class...

class PayrollTab extends StatelessWidget {
  const PayrollTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Pay Period Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Pay Period',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Period:'),
                      Text(
                        'May 1 - May 15, 2024',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pay Date:'),
                      Text(
                        'May 20, 2024',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Latest Payslip Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Latest Payslip',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'April 2024',
                        style: TextStyle(
                          color: Color(0xFF6B2C91),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPayslipRow('Basic Salary', '₱25,000.00'),
                  _buildPayslipRow('Overtime', '₱2,500.00'),
                  _buildPayslipRow('Allowances', '₱3,000.00'),
                  const Divider(),
                  _buildPayslipRow('Gross Pay', '₱30,500.00'),
                  const SizedBox(height: 8),
                  _buildPayslipRow('Tax', '-₱3,050.00', isDeduction: true),
                  _buildPayslipRow('SSS', '-₱1,200.00', isDeduction: true),
                  _buildPayslipRow('PhilHealth', '-₱600.00', isDeduction: true),
                  _buildPayslipRow('Pag-IBIG', '-₱400.00', isDeduction: true),
                  const Divider(),
                  _buildPayslipRow('Net Pay', '₱25,250.00', 
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B2C91),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Inside PayrollTab class, update the download button
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () async {
      try {
        await PayslipPdfService.generatePayslip(
          employeeName: 'John Doe',
          employeeId: 'EMP001',
          period: 'April 2024',
          earnings: {
            'Basic Salary': '₱25,000.00',
            'Overtime': '₱2,500.00',
            'Allowances': '₱3,000.00',
          },
          deductions: {
            'Tax': '₱3,050.00',
            'SSS': '₱1,200.00',
            'PhilHealth': '₱600.00',
            'Pag-IBIG': '₱400.00',
          },
          grossPay: '₱30,500.00',
          netPay: '₱25,250.00',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payslip downloaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating payslip: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6B2C91),
      foregroundColor: Colors.white,
    ),
    child: const Text('Download Payslip'),
  ),
),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Payslip History
          const Text(
            'Payslip History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.description,
                    color: Color(0xFF6B2C91),
                  ),
                  title: Text('April ${2024 - index}'),
                  subtitle: const Text('Net Pay: ₱25,250.00'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      // TODO: Download specific payslip
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipRow(String label, String amount, {
    bool isDeduction = false,
    TextStyle? style,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            amount,
            style: style ?? TextStyle(
              color: isDeduction ? Colors.red : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF6B2C91),
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Software Developer',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),

          // Personal Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.badge, 'Employee ID', 'EMP001'),
                  _buildInfoRow(Icons.email, 'Email', 'john.doe@company.com'),
                  _buildInfoRow(Icons.phone, 'Phone', '+63 912 345 6789'),
                  _buildInfoRow(Icons.calendar_today, 'Date of Birth', 'Jan 1, 1990'),
                  _buildInfoRow(Icons.location_on, 'Address', '123 Main St, City'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Employment Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Employment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.work, 'Department', 'IT Department'),
                  _buildInfoRow(Icons.person_outline, 'Position', 'Software Developer'),
                  _buildInfoRow(Icons.date_range, 'Date Hired', 'Mar 15, 2023'),
                  _buildInfoRow(Icons.supervisor_account, 'Supervisor', 'Jane Smith'),
                  _buildInfoRow(Icons.access_time, 'Employment Status', 'Full-time'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Emergency Contact Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.person, 'Name', 'Mary Doe'),
                  _buildInfoRow(Icons.family_restroom, 'Relationship', 'Spouse'),
                  _buildInfoRow(Icons.phone, 'Phone', '+63 912 345 6789'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement edit profile
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B2C91),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement change password
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: const Color(0xFF6B2C91),
                  ),
                  child: const Text('Change Password'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement logout
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF6B2C91),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// Attendance Tab
// Update AttendanceTab to be stateful
class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  Timer? _timer;
  String _currentTime = '--:--';

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTime();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  void _updateTime() {
    if (mounted) {
      setState(() {
        _currentTime = TimeOfDay.now().format(context);
      });
    }
  }

  void _handleClockIn() {
    TimeTrackingService.clockIn();
    setState(() {}); // Trigger rebuild
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully clocked in!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleClockOut() {
    TimeTrackingService.clockOut();
    setState(() {}); // Trigger rebuild
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully clocked out!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Time Clock',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentTime,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B2C91),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: TimeTrackingService.isClockedIn ? null : _handleClockIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B2C91),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Clock In'),
                      ),
                      ElevatedButton(
                        onPressed: TimeTrackingService.isClockedIn ? _handleClockOut : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Clock Out'),
                      ),
                    ],
                  ),
                  if (TimeTrackingService.clockInTime != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Clocked in at: ${TimeOfDay.fromDateTime(TimeTrackingService.clockInTime!).format(context)}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                  if (TimeTrackingService.clockOutTime != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Clocked out at: ${TimeOfDay.fromDateTime(TimeTrackingService.clockOutTime!).format(context)}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Attendance History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}