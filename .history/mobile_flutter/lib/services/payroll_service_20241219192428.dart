class PayslipData {
  final String employeeName;
  final String employeeId;
  final String period;
  final Map<String, String> earnings;
  final Map<String, String> deductions;
  final String grossPay;
  final String netPay;

  PayslipData({
    required this.employeeName,
    required this.employeeId,
    required this.period,
    required this.earnings,
    required this.deductions,
    required this.grossPay,
    required this.netPay,
  });
}

class PayrollService {
  static PayslipData getLatestPayslip(String period) {
    // This would typically fetch from an API or database
    return PayslipData(
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
  }
}