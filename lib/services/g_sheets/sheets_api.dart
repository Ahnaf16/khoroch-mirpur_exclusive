import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gsheets/gsheets.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final usersCashCollectionProvider = StateNotifierProvider.autoDispose<
    UsersCashCollectionNotifier, List<UsersModel>>((ref) {
  return UsersCashCollectionNotifier()..init();
});

class UsersCashCollectionNotifier extends StateNotifier<List<UsersModel>> {
  UsersCashCollectionNotifier() : super(List.empty());

  final String _cred = r'''
{
  "type": "service_account",
  "project_id": "marjexpense",
  "private_key_id": "8ff3bd9f2f5b855a15eb2d07acd703b31d9b6bc8",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDEQZW9fNc/gNzm\nfUWZFMWWyTT0Z7U/0o+9H+LZWfO9pLDdlPSJzwJ97MHkxEvExGs8jvqxerhXevl4\nASnHD1eBHT1B/8r0wBuIehSTB2z8j49MgaThEVujPWNsn/Fg4DzzWQC+gMOnwFm6\n/uj3Q7R7gCoXIh1WvyLzw+sLPJpL6bS/J9flG2DaLq/nGCncG2oya7OqJOtMZaVH\nKl7m5KyFWy7ORZgYihswmUJKyAp8U6/Ym4GNmOOnXeZ8bRZ7cJ+wXD+E9ZMYSOI3\nhlnf/Q2z5sGkBTXKUBQGP0EwRPqo9T9D1rwyygiObePt1iXiQVl2djxhZhad/WzC\nyYQESVPDAgMBAAECggEAK2rA+D8elWdqNzl+hKuyPLX9l5Y75EcuUm4z7ta2E/3T\nvOl/od8gk4Alsvj0NC8p9CdDcbEPCBdmCjTjq6yKtL8ltqyilzvKu4oadB5/723J\nC2lg8wO2jKn/jV/i9AYXpdRKVFrDLiDhGPvcyRr62hmT9jMvX2oAjwIIRR+emO1S\njGH42DgISW1H4e7kJC5tcIiifRGSdOg6Q9+vv3fePl/qfM3zLxMzoWASuPYNjrcw\nJQ7qXoSxCLVvp/2WhfxFUPzB81cXC7PEeGipz6KMiI/+OOSK02jmBN35ZBzbLt39\n5exjxA5CsDcIzW2Kh7cDzdd3w3VHGRlMW9eEf84b2QKBgQD9KnZfzf5oaeBrcF7/\ndywEqBaq/6ZiwxK7iCC/Tiy5e5RybqbSqdT089iPpH6FyRy4HjUC3I3vQDOofea6\nokkGd0weLJPDRdtps7PNIgJO/b/sUZgXtT90QeqWxDWgB5SM41O1bKai+eSOStM2\nRE0zFerJ/xvu+VJhdE6YJLiVWQKBgQDGdAcFpuMwFd/Mvtsr8mJXcSJiZTCBsdfr\nkmtRRHLPRQfHH2ujAnsmvTr0A+HPRQfcfOQicZmhk2V1EVWE708cDEHPL3zdRX4l\nDlbZi3cb671+1Mh/WMIGdJC68pEOnzPsO02ua1hzpz14jdx0DH6bX/vU7dCGDG5r\na4Ks9KniewKBgQDafPsMU8tscXOtRZ22/DKREj/99AS014YjMqiQcfdHXNAQsk5n\nIQsZHBmaXmyTKa4PeIJnpdEY2l+62m12RPihC/Q1VmNv86oY324da2xyn6wzV3fb\nfiD1RK4gz9U391LNBKQJv2tQ3DnUU99Uxj2aCSBIlFKXO7VNRgNOauKigQKBgG7F\ncun3tlYvz4T0f1fvam8OijfL7aBnCXPHfbmV8FO7X1UJN8Z8aws7kr2DsTZFfNbY\nq2qCaFOk93u52jdicJDiUpV4F0VXNcsvTtENJMXj9xjlYqiafWqnA+Yl4Uv9Fzlj\n/L8/0dZ0Yj55SLVKCB1oHSREPiGkrLmu//jUdEMjAoGAH+a2ybxzwzIOfvQ+MeOU\nqGBnshHZDw9DNKvFpeSta1MeAw5U0NVMGGuO6uYocoeONdk7QSRGIGHZIH18YO9/\n0u+7dyi+o8ya3LgNYYyGGNaPYAUpIlRhMGd4ltWvsCeGZ6bJlBixFNmoj3bEmtBu\nKPqhMpWyF+HMb9KdLge10CM=\n-----END PRIVATE KEY-----\n",
  "client_email": "marj-expense@marjexpense.iam.gserviceaccount.com",
  "client_id": "107289847389387996803",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/marj-expense%40marjexpense.iam.gserviceaccount.com"
}
''';
  final String _sheetsId = '13511oS92joMx892LxVJ0vt3HJ5wGECZxl2GgwFQWO1s';
  final String _ssTitle = 'marj';
  final pefKey = 'rowCount';

  int numberOfRows = 0;

  Worksheet? _worksheet;

  init() async {
    EasyLoading.show(status: 'loading data');
    final pref = await SharedPreferences.getInstance();

    final count = pref.getInt(pefKey);

    final gSheet = GSheets(_cred);

    final spreadSheet = await gSheet.spreadsheet(_sheetsId);

    final workSheet = spreadSheet.worksheetByTitle(_ssTitle);
    _worksheet = workSheet;

    if (count == null) {
      await countRows();
      log('numberOfRows after count: $numberOfRows');
      pref.setInt(pefKey, numberOfRows);
    } else {
      numberOfRows = count;
      log('numberOfRows from pref: $numberOfRows');
    }
    await getAllUser();
    EasyLoading.showSuccess('data loaded');
  }

  countRows() async {
    while ((await _worksheet?.values.value(column: 1, row: numberOfRows + 2)) !=
        '') {
      numberOfRows++;
    }
  }

  getUser(int columnNumber) async {
    List<String> cashCollections = [];
    for (var i = 0; i < numberOfRows; i++) {
      final value =
          await _worksheet?.values.value(column: columnNumber, row: i + 1) ??
              '0';

      if (value.isNotEmpty) {
        cashCollections.add(value);
      }
    }
    final collection = UsersModel(
      name: cashCollections.first,
      collectedCash: cashCollections.sublist(1).map((e) => e.asInt).toList(),
    );
    state = [...state, collection];

    log(collection.toString());
  }

  getAllUser() async {
    List<int> usersColumns = [7, 8, 9];

    for (final column in usersColumns) {
      await getUser(column);
    }
  }

  int get getTotalBalance =>
      state.fold(0, (previous, element) => previous + element.total);
}
