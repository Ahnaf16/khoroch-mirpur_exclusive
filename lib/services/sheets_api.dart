import 'package:gsheets/gsheets.dart';

class SheetsApi {
  final String _cred = r'''
''';
  final String _sheetsId = '';
  final String _ssTitle = '';
  int numberOfRows = 0;
  List transactions = [];

  Worksheet? _worksheet;

  init() async {
    final gSheet = GSheets(_cred);

    final spreadSheet = await gSheet.spreadsheet(_sheetsId);

    final workSheet = spreadSheet.worksheetByTitle(_ssTitle);
    _worksheet = workSheet;
  }
}
