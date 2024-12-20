import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class PayslipPdfService {
  static Future<void> generatePayslip({
    required String employeeName,
    required String period,
    required String employeeId,
    required Map<String, String> earnings,
    required Map<String, String> deductions,
    required String grossPay,
    required String netPay,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text('PAYSLIP', style: pw.TextStyle(fontSize: 24)),
            ),
            pw.SizedBox(height: 20),
            
            // Employee Details
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Employee: $employeeName'),
                  pw.Text('Employee ID: $employeeId'),
                  pw.Text('Period: $period'),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Earnings
            pw.Text('Earnings', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ...earnings.entries.map((entry) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(entry.key),
                pw.Text(entry.value),
              ],
            )),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Gross Pay', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(grossPay, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 20),

            // Deductions
            pw.Text('Deductions', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ...deductions.entries.map((entry) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(entry.key),
                pw.Text(entry.value),
              ],
            )),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Net Pay', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(netPay, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/payslip_$period.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }
}