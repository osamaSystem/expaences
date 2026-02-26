import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../models/expense.dart';

class ExportService {
  Future<String> exportToExcel(List<Expense> expenses) async {
    await _requestPermissionsIfNeeded();

    final excel = Excel.createExcel();
    final sheet = excel['Expenses'];

    sheet.appendRow(<CellValue>[
      TextCellValue('Title'),
      TextCellValue('Amount'),
      TextCellValue('Category'),
      TextCellValue('Date'),
      TextCellValue('Note'),
    ]);

    for (final expense in expenses) {
      sheet.appendRow(<CellValue>[
        TextCellValue(expense.title),
        DoubleCellValue(expense.amount),
        TextCellValue(expense.category.label),
        TextCellValue(DateFormat.yMd().format(expense.date)),
        TextCellValue(expense.note ?? ''),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Failed to generate Excel file.');
    }

    final dir = await _exportDirectory();
    final filePath = p.join(
      dir.path,
      'expenses_${DateTime.now().millisecondsSinceEpoch}.xlsx',
    );
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    return filePath;
  }

  Future<String> exportToPdf(List<Expense> expenses) async {
    await _requestPermissionsIfNeeded();

    final doc = pw.Document();
    final formatter = DateFormat.yMd();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => <pw.Widget>[
          pw.Header(level: 0, child: pw.Text('Expense Tracker Pro - Expenses')),
          pw.TableHelper.fromTextArray(
            headers: <String>['Title', 'Amount', 'Category', 'Date', 'Note'],
            data: expenses
                .map(
                  (expense) => <String>[
                    expense.title,
                    expense.amount.toStringAsFixed(2),
                    expense.category.label,
                    formatter.format(expense.date),
                    expense.note ?? '',
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    final dir = await _exportDirectory();
    final filePath = p.join(
      dir.path,
      'expenses_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );

    final file = File(filePath);
    await file.writeAsBytes(await doc.save(), flush: true);
    return filePath;
  }

  Future<Directory> _exportDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(docsDir.path, 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    return exportDir;
  }

  Future<void> _requestPermissionsIfNeeded() async {
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted && !storageStatus.isLimited) {
        final manageStatus = await Permission.manageExternalStorage.request();
        if (!manageStatus.isGranted) {
          // Export still works in app-docs on many devices; don't hard fail.
        }
      }
    }
  }
}
