import 'dart:convert';
import 'dart:developer';

String prettyJSON(response) {
  var encoder = const JsonEncoder.withIndent("  ");
  return encoder.convert(response);
}

logJSON(response) => log(prettyJSON(response));
