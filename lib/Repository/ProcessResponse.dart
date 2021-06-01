
import 'package:onvif/BLOC.dart';
import 'package:onvif/Model/OnvifDevice.dart';
import 'package:onvif/Model/ProbeMatch.dart';
import 'package:onvif/Repository/ParseData.dart';
import 'package:onvif/Repository/Utils.dart';

void readResponse(String probes){
    final Map<String,String> aProbeMatch = readProbeMatches(probes);
    if (aProbeMatch.isNotEmpty){
      List<String> types = aProbeMatch['Types'].split(" ");
      List<String> scopes = aProbeMatch['Scopes'].split(" ");
      removeFreeScopes(scopes);
      List<String> xAddrs = aProbeMatch['XAddrs'].split(" ");
      ProbeMatch  probeMatchObject = ProbeMatch(
      types, scopes , xAddrs,
      aProbeMatch['MetadataVersion'], 
      aProbeMatch['Address']);
      probeMatchData.add(probeMatchObject);
    }
  }
   Future<OnvifDevice> processMatch(ProbeMatch aProbeMatch)async{
    OnvifDevice onvifDev = OnvifDevice();
    String aSystemDateAndTime = await checkXAddrsAndGetTime(onvifDev, aProbeMatch,(device){onvifDev= device;});
    DateTime deviceTime = parseSystemDateAndTime(aSystemDateAndTime);
    onvifDev.timeOffset = deviceTime ; 
    return onvifDev;
  }
  Future<String> checkXAddrsAndGetTime(OnvifDevice onvifDev ,ProbeMatch aProbeMatch , Function(OnvifDevice)done)async{
    for(String xAddr in aProbeMatch.xAddrs){
      String aSystemDateAndTime = await onvifDev.getSystemDateAndTime(xaddr: xAddr);
      if(aSystemDateAndTime != null){
        onvifDev.xAddr = xAddr;
        done(onvifDev);
        return aSystemDateAndTime;
      }
    }
    return "";
  }