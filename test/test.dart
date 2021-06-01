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
  test('readProbeMatches', () async {
    var input = await File('test/fixtures/ProbeMatches.xml').readAsString();
    var output = readProbeMatches(input);
    expect(output['Types'], equals('dn:NetworkVideoTransmitter'));
    expect(output['Scopes'], equals('onvif://www.onvif.org/type/video_encoder  onvif://www.onvif.org/type/audio_encoder  onvif://www.onvif.org/hardware/MODEL  onvif://www.onvif.org/name/VENDOR%20MODEL  onvif://www.onvif.org/location/ANY'));
    expect(output['XAddrs'], equals('http://169.254.76.145/onvif/services http://192.168.1.24/onvif/services'));
    expect(output['MetadataVersion'], equals('1'));
    expect(output['Address'], equals('urn:uuid:a1f48ac2-dc8b-11df-b255-00408c1836b2'));
  });
}
