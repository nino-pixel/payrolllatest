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
        pageFormat: PdfPageFormat.a4,  // Using PdfPageFormat from pdf/pdf.dart
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(
                'PAYSLIP', 
                style: pw.TextStyle(
                  fontSize: 24,
                  color: PdfColors.purple900,  // Using PdfColors from pdf/pdf.dart
                )
              ),
            ),
            // ... rest of your existing code ...
          ],
        ),
      ),
    );

    // ... rest of your existing code ...
  }
}