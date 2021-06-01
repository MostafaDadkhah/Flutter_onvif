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

Future<DateTime> parseSystemDateAndTime(String aSystemDateAndTime)async{
  String timeType = "tt:UTCDateTime";
  final document = xml.parse(aSystemDateAndTime);
  String prefix = "SOAP-ENV";
    bool  body = document.findAllElements("SOAP-ENV:Body").isEmpty;
       if (body){
         prefix = "s";
       }
  String utcDateTime = document.findAllElements("$prefix:Envelope")
  .map((body)=> body.findAllElements("$prefix:Body")
  .map((getSystemDateAndTimeResponse)=> getSystemDateAndTimeResponse.findAllElements("tds:GetSystemDateAndTimeResponse")
  .map((systemDateAndTime)=> systemDateAndTime.findAllElements("tds:SystemDateAndTime")
  .map((utcDateTime)=> utcDateTime.findAllElements("tt:UTCDateTime").isNotEmpty)))).toString();
  utcDateTime = removePranteces(utcDateTime);
 
  if (utcDateTime != 'true'){
    timeType = "tt:LocalDateTime";
  }
   String hour = document.findAllElements("$prefix:Envelope")
  .map((body)=> body.findAllElements("$prefix:Body")
  .map((getSystemDateAndTimeResponse)=> getSystemDateAndTimeResponse.findAllElements("tds:GetSystemDateAndTimeResponse")
  .map((systemDateAndTime)=> systemDateAndTime.findAllElements("tds:SystemDateAndTime")
  .map((localDateTime)=> localDateTime.findAllElements(timeType)
  .map((time)=> time.findAllElements("tt:Time")
  .map((hour)=> hour.findAllElements("tt:Hour").single.text)))))).toString();

  String  minute = document.findAllElements("$prefix:Envelope")
  .map((body)=> body.findAllElements("$prefix:Body")
  .map((getSystemDateAndTimeResponse)=> getSystemDateAndTimeResponse.findAllElements("tds:GetSystemDateAndTimeResponse")
  .map((systemDateAndTime)=> systemDateAndTime.findAllElements("tds:SystemDateAndTime")
  .map((localDateTime)=> localDateTime.findAllElements(timeType)
  .map((time)=> time.findAllElements("tt:Time")
  .map((minute)=> minute.findAllElements("tt:Minute").single.text)))))).toString();

  String second = document.findAllElements("$prefix:Envelope")
  .map((body)=> body.findAllElements("$prefix:Body")
  .map((getSystemDateAndTimeResponse)=> getSystemDateAndTimeResponse.findAllElements("tds:GetSystemDateAndTimeResponse")
  .map((systemDateAndTime)=> systemDateAndTime.findAllElements("tds:SystemDateAndTime")
  .map((localDateTime)=> localDateTime.findAllElements(timeType)
  .map((time)=> time.findAllElements("tt:Time")
  .map((second)=> second.findAllElements("tt:Second").single.text)))))).toString();

  String year = document.findAllElements("$prefix:Envelope")
  .map((body)=> body.findAllElements("$prefix:Body")
  .map((getSystemDateAndTimeResponse)=> getSystemDateAndTimeResponse.findAllElements("tds:GetSystemDateAndTimeResponse")
  .map((systemDateAndTime)=> systemDateAndTime.findAllElements("tds:SystemDateAndTime")
  .map((localDateTime)=> localDateTime.findAllElements(timeType)
  .map((date)=> date.findAllElements("tt:Date")
  .map((year)=> year.findAllElements("tt:Year").single.text)))))).toString();

  String month = document.findAllElements("$prefix:Envelope")
  .map((body)=> body.findAllElements("$prefix:Body")
  .map((getSystemDateAndTimeResponse)=> getSystemDateAndTimeResponse.findAllElements("tds:GetSystemDateAndTimeResponse")
  .map((systemDateAndTime)=> systemDateAndTime.findAllElements("tds:SystemDateAndTime")
  .map((localDateTime)=> localDateTime.findAllElements(timeType)
  .map((date)=> date.findAllElements("tt:Date")
  .map((month)=> month.findAllElements("tt:Month").single.text)))))).toString();

  String day = document.findAllElements("$prefix:Envelope")
  .map((body)=> body.findAllElements("$prefix:Body")
  .map((getSystemDateAndTimeResponse)=> getSystemDateAndTimeResponse.findAllElements("tds:GetSystemDateAndTimeResponse")
  .map((systemDateAndTime)=> systemDateAndTime.findAllElements("tds:SystemDateAndTime")
  .map((localDateTime)=> localDateTime.findAllElements(timeType)
  .map((date)=> date.findAllElements("tt:Date")
  .map((day)=> day.findAllElements("tt:Day").single.text)))))).toString();

  return DateTime(
    int.parse(removePranteces(year)),
    int.parse(removePranteces(month)),
    int.parse(removePranteces(day)),
    int.parse(removePranteces(hour)),
    int.parse(removePranteces(minute)),
    int.parse(removePranteces(second)),
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