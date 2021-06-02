import 'package:onvif/Model/NetworkProtocol.dart';
import 'package:onvif/Repository/Utils.dart';
import 'package:xml/xml.dart';

Map<String,String> readProbeMatches(String input) {
  final document = parse(input);
  final relatesToElements = document.findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
    return e.findElements('Header', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((h) {
      return h.findElements('RelatesTo', namespace: 'http://schemas.xmlsoap.org/ws/2004/08/addressing');
    });
  });
  if (relatesToElements.isEmpty) {
    return {};
  }

  final probeMatchElements = document.findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
    return e.findElements('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((b) {
      return b.findElements('ProbeMatches', namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery').expand((pms) {
        return pms.findElements('ProbeMatch', namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery');
      });
    });
  });

  if (probeMatchElements.isEmpty) {
    return {};
  }

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
  final systemDateAndTimes = parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
    return e.findElements('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((b) {
      return b.findElements('GetSystemDateAndTimeResponse', namespace: 'http://www.onvif.org/ver10/device/wsdl').expand((gsdatr) {
        return gsdatr.findElements('SystemDateAndTime', namespace: 'http://www.onvif.org/ver10/device/wsdl');
      });
    });
  });
  if (systemDateAndTimes.isEmpty) {
    return null;
  }

  final systemDateAndTime = systemDateAndTimes.first;
  final utcDateTimes = systemDateAndTime.findElements('UTCDateTime', namespace: 'http://www.onvif.org/ver10/schema');
  XmlElement dateTime;
  if (utcDateTimes.isEmpty) {
    final localDateTimes = systemDateAndTime.findElements('LocalDateTime', namespace: 'http://www.onvif.org/ver10/schema');
    if (localDateTimes.isEmpty) {
      return null;
    }

    dateTime = localDateTimes.first;
  } else {
    dateTime = utcDateTimes.first;
  }

  final dates = dateTime.findElements('Date', namespace: 'http://www.onvif.org/ver10/schema');
  if (dates.isEmpty) {
    return null;
  }

  final date = dates.first;
  final years = date.findElements('Year', namespace: 'http://www.onvif.org/ver10/schema');
  final months = date.findElements('Month', namespace: 'http://www.onvif.org/ver10/schema');
  final days = date.findElements('Day', namespace: 'http://www.onvif.org/ver10/schema');
  if (years.isEmpty || months.isEmpty || days.isEmpty) {
    return null;
  }

  final times = dateTime.findElements('Time', namespace: 'http://www.onvif.org/ver10/schema');
  if (times.isEmpty) {
    return null;
  }

  final time = times.first;
  final hours = time.findElements('Hour', namespace: 'http://www.onvif.org/ver10/schema');
  final minutes = time.findElements('Minute', namespace: 'http://www.onvif.org/ver10/schema');
  final seconds = time.findElements('Second', namespace: 'http://www.onvif.org/ver10/schema');
  if (hours.isEmpty || minutes.isEmpty || seconds.isEmpty) {
    return null;
  }

  return DateTime(
    int.parse(years.first.text), int.parse(months.first.text), int.parse(days.first.text),
    int.parse(hours.first.text), int.parse(minutes.first.text), int.parse(seconds.first.text)
  );
}

Map<String,String> parseGetDeviceInformation(String input) {
  final elements = parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
    return e.findElements('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((b) {
      return b.findElements('GetDeviceInformationResponse', namespace: 'http://www.onvif.org/ver10/device/wsdl');
    });
  });
  if (elements.isEmpty) {
    return {};
  }

  final result = <String,String>{};

  final modelElements = elements.first.findElements('Model', namespace: 'http://www.onvif.org/ver10/device/wsdl');
  if (modelElements.isNotEmpty) {
    result['model'] = modelElements.first.text;
  }

  final serialNumberElements = elements.first.findElements('SerialNumber', namespace: 'http://www.onvif.org/ver10/device/wsdl');
  if (serialNumberElements.isNotEmpty) {
    result['serialNumber'] = serialNumberElements.first.text;
  }

  return result;
}

Map<String,String> parseGetCapabilities(String input) {
  final elements = parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
    return e.findElements('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((b) {
      return b.findElements('GetCapabilitiesResponse', namespace: 'http://www.onvif.org/ver10/device/wsdl').expand((gcr) {
        return gcr.findElements('Capabilities', namespace: 'http://www.onvif.org/ver10/device/wsdl');
      });
    });
  });
  if (elements.isEmpty) {
    return {};
  }

  final result = <String , String>{};

  final deviceXAddrElements = elements.first.findElements('Device', namespace: 'http://www.onvif.org/ver10/schema').expand((d) {
    return d.findElements('XAddr', namespace: 'http://www.onvif.org/ver10/schema');
  });
  if (deviceXAddrElements.isNotEmpty) {
    result['XAddr'] = deviceXAddrElements.map((e) => e.text).join(' ');
  }

  final eventsXAddrElements = elements.first.findElements('Events', namespace: 'http://www.onvif.org/ver10/schema').expand((es) {
    return es.findElements('XAddr', namespace: 'http://www.onvif.org/ver10/schema');
  });
  if (eventsXAddrElements.isNotEmpty) {
    result['Events'] = eventsXAddrElements.map((e) => e.text).join(' ');
  }

  final mediaXAddrElements = elements.first.findElements('Media', namespace: 'http://www.onvif.org/ver10/schema').expand((m) {
    return m.findElements('XAddr', namespace: 'http://www.onvif.org/ver10/schema');
  });
  if (mediaXAddrElements.isNotEmpty) {
    result['Media'] = mediaXAddrElements.map((e) => e.text).join(' ');
  }

  final systemLoggingElements = elements.first.findElements('Device', namespace: 'http://www.onvif.org/ver10/schema').expand((d) {
    return d.findElements('System', namespace: 'http://www.onvif.org/ver10/schema').expand((s) {
      return s.findElements('SystemLogging', namespace: 'http://www.onvif.org/ver10/schema');
    });
  });
  if (systemLoggingElements.isNotEmpty) {
    result['log'] = systemLoggingElements.map((e) => e.text).join(' ');
  }

  return result;
}

List<NetworkProtocol>parseGetNetworkProtocols(String input) {
  final protocols = parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
    return e.findElements('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((b) {
      return b.findElements('GetNetworkProtocolsResponse', namespace: 'http://www.onvif.org/ver10/device/wsdl').expand((gnpr) {
        return gnpr.findElements('NetworkProtocols', namespace: 'http://www.onvif.org/ver10/device/wsdl').map((nps) {
          final name = nps.findElements('Name', namespace: 'http://www.onvif.org/ver10/schema');
          final enabled = nps.findElements('Enabled', namespace: 'http://www.onvif.org/ver10/schema');
          final port = nps.findElements('Port', namespace: 'http://www.onvif.org/ver10/schema');
          if (name.isEmpty || enabled.isEmpty || port.isEmpty) {
            return null;
          }

          return NetworkProtocol(name.first.text, enabled.first.text == 'true', int.parse(port.first.text));
        });
      });
    });
  });

  return protocols.where((p) => p != null).toList();
}

List<String>parseGetProfiles(String input) {
  final elements = parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
    return e.findElements('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((b) {
      return b.findElements('GetProfilesResponse', namespace: 'http://www.onvif.org/ver10/media/wsdl').expand((gpr) {
        return gpr.findElements('Profiles', namespace: 'http://www.onvif.org/ver10/media/wsdl').map((ps) {
          return ps.getAttribute('token');
        });
      });
    });
  });

  return elements.where((e) => e != null).toList();
}

String parseGetMediaUri(String input) {
  final elements = parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
    return e.findElements('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((b) {
      return b.findElements('GetStreamUriResponse', namespace: 'http://www.onvif.org/ver10/media/wsdl').expand((gsur) {
        return gsur.findElements('MediaUri', namespace: 'http://www.onvif.org/ver10/media/wsdl').expand((mu) {
          return mu.findElements('Uri', namespace: 'http://www.onvif.org/ver10/schema');
        });
      });
    });
  });
  if (elements.isEmpty) {
    return null;
  }

  return elements.first.text;
}