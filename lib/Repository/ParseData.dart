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
List<NetworkProtocol>parseGetNetworkProtocols(String info){
    xml.XmlDocument document = xml.parse(info);
       String prefix = "SOAP-ENV";
    String name = document.findAllElements("$prefix:Envelope")
    .map((body)=> body.findAllElements("$prefix:Body")
    .map((getNetworkProtocolsResponse)=> getNetworkProtocolsResponse.findAllElements("tds:GetNetworkProtocolsResponse")
    .map((networkProtocols)=> networkProtocols.findAllElements("tds:NetworkProtocols")
    .map((name)=> name.findAllElements("tt:Name").single.text)))).toString();
    name = removePranteces(name);
    List<String> names = name.split(',');

    String enabled = document.findAllElements("$prefix:Envelope")
    .map((body)=> body.findAllElements("$prefix:Body")
    .map((getNetworkProtocolsResponse)=> getNetworkProtocolsResponse.findAllElements("tds:GetNetworkProtocolsResponse")
    .map((networkProtocols)=> networkProtocols.findAllElements("tds:NetworkProtocols")
    .map((enabled)=> enabled.findAllElements("tt:Enabled").single.text)))).toString();
    enabled = removePranteces(enabled);
    List<String>enableds = enabled.split(',');

    String port = document.findAllElements("$prefix:Envelope")
    .map((body)=> body.findAllElements("$prefix:Body")
    .map((getNetworkProtocolsResponse)=> getNetworkProtocolsResponse.findAllElements("tds:GetNetworkProtocolsResponse")
    .map((networkProtocols)=> networkProtocols.findAllElements("tds:NetworkProtocols")
    .map((port)=> port.findAllElements("tt:Port").single.text)))).toString();
    port = removePranteces(port);
    List<String> ports = port.split(',');
    List<NetworkProtocol> list = [];
    for (int i= 0 ; i< names.length ; i++){
       NetworkProtocol npObject = NetworkProtocol(names[i].trim(), (enableds[i].trim() == 'true'), int.parse(ports[i]));
       list.add(npObject);
    }
    return list;
  }  
List<String>parseGetProfiles(String profiles){
   xml.XmlDocument document = xml.parse(profiles);
     String prefix = "SOAP-ENV";
    String token = document.findAllElements("$prefix:Envelope")
    .map((body)=> body.findAllElements("$prefix:Body")
    .map((getProfilesResponse)=> getProfilesResponse.findAllElements("trt:GetProfilesResponse")
    .map((profiles)=> profiles.findAllElements("trt:Profiles")
    .map((token)=> token.attributes)))).toString();
    token = removePranteces(token);
    List<String> tokenLists = token.split(',');
    tokenLists = removeFreeProfileAttributes(tokenLists);
    return tokenLists;
}
String parseGetMediaUri(String result){
   xml.XmlDocument document = xml.parse(result);
     String prefix = "SOAP-ENV";
    String uri = document.findAllElements("$prefix:Envelope")
    .map((body)=> body.findAllElements("SOAP-ENV:Body")
    .map((getStreamUri)=> getStreamUri.findAllElements("trt:GetStreamUriResponse")
    .map((mediaUri)=>mediaUri.findAllElements("trt:MediaUri")
    .map((uri)=>uri.findAllElements("tt:Uri").single.text)))).toString();
    return removePranteces(uri);
}