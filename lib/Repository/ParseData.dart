import 'package:onvif/Model/NetworkProtocol.dart';
import 'package:onvif/Repository/Utils.dart';
import 'package:xml/xml.dart';

Map<String,String> readProbeMatches(String input) {
  final document = parse(input);
  final relatesToElement = document
    .getElement('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('Header', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('RelatesTo', namespace: 'http://schemas.xmlsoap.org/ws/2004/08/addressing');
  if (relatesToElement == null) { return {}; }

  final probeMatchElements = document
    .getElement('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('ProbeMatches', namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery')
    ?.findElements('ProbeMatch', namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery');
  if (probeMatchElements == null) { return {}; }

  final result = <String, String>{};
 
  final typesElements = probeMatchElements.expand((pm) {
    return pm.findElements('Types', namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery');
  });
  if (typesElements.isNotEmpty) {
    result['Types'] = typesElements.map((e) => e.text).join(' ');
  }

  final scopesElements = probeMatchElements.expand((pm) {
    return pm.findElements('Scopes', namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery');
  });
  if (scopesElements.isNotEmpty) {
    result['Scopes'] = scopesElements.map((e) => e.text).join(' ');
  }

  final xAddrsElements = probeMatchElements.expand((pm) {
    return pm.findElements('XAddrs', namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery');
  });
  if (xAddrsElements.isNotEmpty) {
    result['XAddrs'] = xAddrsElements.map((e) => e.text).join(' ');
  }
        
  final metadataVersionElements = probeMatchElements.expand((pm) {
    return pm.findElements('MetadataVersion', namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery');
  });
  if (metadataVersionElements.isNotEmpty) {
    result['MetadataVersion'] = metadataVersionElements.map((e) => e.text).join(' ');
  }

  final addressElements = probeMatchElements.expand((pm) {
    return pm.findElements('EndpointReference', namespace: 'http://schemas.xmlsoap.org/ws/2004/08/addressing').expand((er) {
      return er.findElements('Address', namespace: 'http://schemas.xmlsoap.org/ws/2004/08/addressing');
    });
  });
  if (metadataVersionElements.isNotEmpty) {
    result['Address'] = addressElements.map((e) => e.text).join(' ');
  }

  return result;
}

DateTime parseSystemDateAndTime(String input) {
  final systemDateAndTime = parse(input)
    .getElement('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('GetSystemDateAndTimeResponse', namespace: 'http://www.onvif.org/ver10/device/wsdl')
    ?.getElement('SystemDateAndTime', namespace: 'http://www.onvif.org/ver10/device/wsdl');
  if (systemDateAndTime == null) {
    return null;
  }

  final dateTime = systemDateAndTime.getElement('UTCDateTime', namespace: 'http://www.onvif.org/ver10/schema') ??
    systemDateAndTime.getElement('LocalDateTime', namespace: 'http://www.onvif.org/ver10/schema');
  if (dateTime == null) {
    return null;
  }

  final date = dateTime.getElement('Date', namespace: 'http://www.onvif.org/ver10/schema');
  if (date == null) {
    return null;
  }

  final year = date.getElement('Year', namespace: 'http://www.onvif.org/ver10/schema');
  final month = date.getElement('Month', namespace: 'http://www.onvif.org/ver10/schema');
  final day = date.getElement('Day', namespace: 'http://www.onvif.org/ver10/schema');
  if (year == null || month == null || day == null) {
    return null;
  }

  final time = dateTime.getElement('Time', namespace: 'http://www.onvif.org/ver10/schema');
  if (time == null) {
    return null;
  }

  final hour = time.getElement('Hour', namespace: 'http://www.onvif.org/ver10/schema');
  final minute = time.getElement('Minute', namespace: 'http://www.onvif.org/ver10/schema');
  final second = time.getElement('Second', namespace: 'http://www.onvif.org/ver10/schema');
  if (hour == null || minute == null || second == null) {
    return null;
  }

  return DateTime(
    int.parse(year.text), int.parse(month.text), int.parse(day.text),
    int.parse(hour.text), int.parse(minute.text), int.parse(second.text)
  );
}

Map<String,String> parseGetDeviceInformation(String input) {
  final responseElement = parse(input)
    .getElement('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('GetDeviceInformationResponse', namespace: 'http://www.onvif.org/ver10/device/wsdl');
  if (responseElement == null) {
    return {};
  }

  final result = <String,String>{};

  final modelElement = responseElement.getElement('Model', namespace: 'http://www.onvif.org/ver10/device/wsdl');
  if (modelElement != null) {
    result['model'] = modelElement.text;
  }

  final serialNumberElement = responseElement.getElement('SerialNumber', namespace: 'http://www.onvif.org/ver10/device/wsdl');
  if (serialNumberElement != null) {
    result['serialNumber'] = serialNumberElement.text;
  }

  return result;
}

Map<String,String> parseGetCapabilities(String input) {
  final capabilitiesElement = parse(input)
    .getElement('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('GetCapabilitiesResponse', namespace: 'http://www.onvif.org/ver10/device/wsdl')
    ?.getElement('Capabilities', namespace: 'http://www.onvif.org/ver10/device/wsdl');
  if (capabilitiesElement == null) {
    return {};
  }

  final result = <String , String>{};

  final deviceXAddrElement = capabilitiesElement
    .getElement('Device', namespace: 'http://www.onvif.org/ver10/schema')
    ?.getElement('XAddr', namespace: 'http://www.onvif.org/ver10/schema');
  if (deviceXAddrElement != null) {
    result['XAddr'] = deviceXAddrElement.text;
  }

  final eventsXAddrElement = capabilitiesElement
    .getElement('Events', namespace: 'http://www.onvif.org/ver10/schema')
    ?.getElement('XAddr', namespace: 'http://www.onvif.org/ver10/schema');
  if (eventsXAddrElement != null) {
    result['Events'] = eventsXAddrElement.text;
  }

  final mediaXAddrElement = capabilitiesElement
    .getElement('Media', namespace: 'http://www.onvif.org/ver10/schema')
    ?.getElement('XAddr', namespace: 'http://www.onvif.org/ver10/schema');
  if (mediaXAddrElement != null) {
    result['Media'] = mediaXAddrElement.text;
  }

  final systemLoggingElement = capabilitiesElement
    .getElement('Device', namespace: 'http://www.onvif.org/ver10/schema')
    ?.getElement('System', namespace: 'http://www.onvif.org/ver10/schema')
    ?.getElement('SystemLogging', namespace: 'http://www.onvif.org/ver10/schema');
  if (systemLoggingElement != null) {
    result['log'] = systemLoggingElement.text;
  }

  return result;
}

List<NetworkProtocol>parseGetNetworkProtocols(String input) {
  final protocols = parse(input)
    .getElement('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('GetNetworkProtocolsResponse', namespace: 'http://www.onvif.org/ver10/device/wsdl')
    ?.findElements('NetworkProtocols', namespace: 'http://www.onvif.org/ver10/device/wsdl').map((nps) {
      final name = nps.getElement('Name', namespace: 'http://www.onvif.org/ver10/schema');
      final enabled = nps.getElement('Enabled', namespace: 'http://www.onvif.org/ver10/schema');
      final port = nps.getElement('Port', namespace: 'http://www.onvif.org/ver10/schema');
      if (name == null || enabled == null || port == null) {
        return null;
      }

      return NetworkProtocol(name.text, enabled.text == 'true', int.parse(port.text));
    });
  if (protocols == null) { return []; }

  return protocols.where((p) => p != null).toList();
}

List<String>parseGetProfiles(String input) {
  final tokens = parse(input)
    .getElement('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('GetProfilesResponse', namespace: 'http://www.onvif.org/ver10/media/wsdl')
    ?.findElements('Profiles', namespace: 'http://www.onvif.org/ver10/media/wsdl').map((ps) {
      return ps.getAttribute('token');
    });
  if (tokens == null) { return []; }

  return tokens.where((e) => e != null).toList();
}

String parseGetMediaUri(String input) {
  return parse(input)
    .getElement('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope')
    ?.getElement('GetStreamUriResponse', namespace: 'http://www.onvif.org/ver10/media/wsdl')
    ?.getElement('MediaUri', namespace: 'http://www.onvif.org/ver10/media/wsdl')
    ?.getElement('Uri', namespace: 'http://www.onvif.org/ver10/schema')
    ?.text;
}
