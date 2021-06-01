import 'package:onvif/Model/NetworkProtocol.dart';
import 'package:onvif/Repository/Utils.dart';
import 'package:xml/xml.dart' as xml;

Map<String,String> readProbeMatches(String probe){
    Map <String , String> aProbeMatch = <String, String>{};
      final document = xml.parse(probe);
      String prefix = "SOAP-ENV";
      String header = document.findAllElements("SOAP-ENV:Header")
      .map((relatesTo)=> relatesTo.findAllElements("wsa:RelatesTo").single.text).toString();
       if (removePranteces(header) == ""){
         prefix = "s";
       }
 
        String types = document.findAllElements("$prefix:Body")
        .map((probeMatches)=> probeMatches.findAllElements("d:ProbeMatches")
        .map((probeMatch)=> probeMatch.findAllElements("d:ProbeMatch")
        .map((type)=> type.findAllElements('d:Types').single.text))).toString();
        types = removePranteces(types);

         aProbeMatch['Types'] = types;

        String scopes = document.findAllElements("$prefix:Body")
        .map((probeMatches)=> probeMatches.findAllElements("d:ProbeMatches")
        .map((probeMatch)=> probeMatch.findAllElements("d:ProbeMatch")
        .map((type)=> type.findAllElements('d:Scopes').single.text))).toString();
        scopes = removePranteces(scopes);
        aProbeMatch['Scopes'] = scopes;

         String xAddrs = document.findAllElements("$prefix:Body")
        .map((probeMatches)=> probeMatches.findAllElements("d:ProbeMatches")
        .map((probeMatch)=> probeMatch.findAllElements("d:ProbeMatch")
        .map((type)=> type.findAllElements('d:XAddrs').single.text))).toString();
        xAddrs = removePranteces(xAddrs);
        aProbeMatch['XAddrs'] = xAddrs;
        
        String metaDataVersion = document.findAllElements("$prefix:Body")
        .map((probeMatches)=> probeMatches.findAllElements("d:ProbeMatches")
        .map((probeMatch)=> probeMatch.findAllElements("d:ProbeMatch")
        .map((type)=> type.findAllElements('d:MetadataVersion').single.text))).toString();
        metaDataVersion = removePranteces(metaDataVersion);
        aProbeMatch['MetadataVersion'] = metaDataVersion;

        String address = document.findAllElements("$prefix:Body")
        .map((probeMatches)=> probeMatches.findAllElements("d:ProbeMatches")
        .map((probeMatch)=> probeMatch.findAllElements("d:ProbeMatch")
        .map((endPointRefrence)=> endPointRefrence.findAllElements("wsa:EndpointReference")
        .map((address)=> address.findAllElements("wsa:Address").single.text)))).toString();
        address = removePranteces(address);
        aProbeMatch["Address"] = address;
        return aProbeMatch;
   
}

DateTime parseSystemDateAndTime(String input) {
  final systemDateAndTimes = xml.parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
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
  xml.XmlElement dateTime;
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

Map<String,String> parseGetDeviceInformation(String information){
 Map<String,String>deviceInformation = <String,String>{};
   xml.XmlDocument document = xml.parse(information);
    String prefix = "SOAP-ENV";
    String model = document.findAllElements("$prefix:Envelope")
    .map((body)=> body.findAllElements("$prefix:Body")
    .map((getDeviceInformationResponse)=> getDeviceInformationResponse.findAllElements("tds:GetDeviceInformationResponse")
    .map((model)=> model.findAllElements("tds:Model").single.text))).toString();
    deviceInformation['model'] = removePranteces(model);

    String serialNumber = document.findAllElements("$prefix:Envelope")
    .map((body)=> body.findAllElements("$prefix:Body")
    .map((getDeviceInformationResponse)=> getDeviceInformationResponse.findAllElements("tds:GetDeviceInformationResponse")
    .map((serialNumber)=> serialNumber.findAllElements("tds:SerialNumber").single.text))).toString();
    deviceInformation['serialNumber'] = removePranteces(serialNumber);
    return deviceInformation;
}
Map<String,String> parseGetCapabilities(String information){
   Map <String,String> capablitiesData = <String , String>{};
        xml.XmlDocument document = xml.parse(information);
       String prefix = "SOAP-ENV";
      String _xAddr = document.findAllElements("$prefix:Envelope")
        .map((body)=> body.findAllElements("$prefix:Body")
        .map((getCapabilitiesResponse)=>getCapabilitiesResponse.findAllElements("tds:GetCapabilitiesResponse")
        .map((capabilities)=> capabilities.findAllElements("tds:Capabilities")
        .map((device)=> device.findAllElements("tt:Device")
        .map((xAddr)=>xAddr.findAllElements("tt:XAddr").single.text))))).toString();
        capablitiesData['XAddr'] = removePranteces(_xAddr);

      String events = document.findAllElements("$prefix:Envelope")
        .map((body)=> body.findAllElements("SOAP-ENV:Body")
        .map((getCapabilitiesResponse)=>getCapabilitiesResponse.findAllElements("tds:GetCapabilitiesResponse")
        .map((capabilities)=> capabilities.findAllElements("tds:Capabilities")
        .map((events)=> events.findAllElements("tt:Events")
        .map((xAddr)=>xAddr.findAllElements("tt:XAddr").single.text))))).toString();
        capablitiesData['Events'] = removePranteces(events);

        String media = document.findAllElements("$prefix:Envelope")
        .map((body)=> body.findAllElements("$prefix:Body")
        .map((getCapabilitiesResponse)=>getCapabilitiesResponse.findAllElements("tds:GetCapabilitiesResponse")
        .map((capabilities)=> capabilities.findAllElements("tds:Capabilities")
        .map((media)=> media.findAllElements("tt:Media")
        .map((xAddr)=>xAddr.findAllElements("tt:XAddr").single.text))))).toString();
        capablitiesData['Media'] = removePranteces(media);

        String logging = document.findAllElements("$prefix:Envelope")
        .map((body)=> body.findAllElements("$prefix:Body")
        .map((getCapabilitiesResponse)=>getCapabilitiesResponse.findAllElements("tds:GetCapabilitiesResponse")
        .map((capabilities)=> capabilities.findAllElements("tds:Capabilities")
        .map((device)=> device.findAllElements("tt:Device")
        .map((system)=>system.findAllElements("tt:System")
        .map((systemLogging)=> systemLogging.findAllElements("tt:SystemLogging").single.text)))))).toString();
        capablitiesData['log'] = removePranteces(logging);
        return capablitiesData;
  }

List<NetworkProtocol>parseGetNetworkProtocols(String input) {
  final protocols = xml.parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
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
  final elements = xml.parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
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
  final elements = xml.parse(input).findElements('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope').expand((e) {
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