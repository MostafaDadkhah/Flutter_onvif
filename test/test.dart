import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';

import 'package:onvif/onvif.dart';
import 'package:onvif/Repository/ParseData.dart';

void main() {
  test('Test Discovery', () {
    var onvif = ONVIF();
  });
  test('parseSystemDateAndTime', () async {
    var input = await File('test/fixtures/GetSystemDateAndTimeResponse.xml').readAsString();
    var output = await parseSystemDateAndTime(input);
    expect(output, equals(DateTime(2010, 10, 29, 15, 52, 25)));
  });
}
