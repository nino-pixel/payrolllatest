import 'package:flutter/material.dart';

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
            children: [
              _buildQuickActionCard(
                icon: Icons.access_time,
                title: 'Clock In/Out',
                onTap: () {
                  // TODO: Implement clock in/out
                },
              ),
              _buildQuickActionCard(
                icon: Icons.description,
                title: 'Latest Payslip',
                onTap: () {
                  // TODO: Show latest payslip
                },
              ),
              _buildQuickActionCard(
                icon: Icons.calendar_today,
                title: 'Request Leave',
                onTap: () {
                  // TODO: Open leave request form
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
// Attendance Tab
class AttendanceTab extends StatelessWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Clock Card
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
                  const Text(
                    '08:00 AM',
                    style: TextStyle(
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
                        onPressed: () {
                          // TODO: Implement clock in
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B2C91),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Clock In'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement clock out
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Clock Out'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Attendance History
          const Text(
            'Attendance History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Show last 5 records
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.access_time,
                    color: Color(0xFF6B2C91),
                  ),
                  title: Text('May ${15 - index}, 2024'),
                  subtitle: const Text('In: 8:00 AM - Out: 5:00 PM'),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Leave Balance Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leave Balance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLeaveBalanceRow('Annual Leave', 15),
                  _buildLeaveBalanceRow('Sick Leave', 7),
                  _buildLeaveBalanceRow('Emergency Leave', 3),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Open leave request form
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B2C91),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Request Leave'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceRow(String type, int days) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type),
          Text(
            '$days days',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B2C91),
            ),
          ),
        ],
      ),
    );
  }
}