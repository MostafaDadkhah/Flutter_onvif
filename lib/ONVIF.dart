library onvif;
import 'dart:async';
import 'package:onvif/Model/OnvifDevice.dart';
import 'BLOC.dart';
import 'Model/NetworkProtocol.dart';
import 'Model/Probe.dart';
import 'Model/ProbeMatch.dart';
import 'Repository/ParseData.dart';
import 'Repository/ProcessResponse.dart';
import 'Repository/SendData.dart';
import 'Repository/Utils.dart';
import 'Repository/buildMessages.dart';

class ONVIF{

ONVIF();
 void  getDevices(Function(OnvifDevice)onDone) async {
  List<ProbeMatch> probeMatchList = [];
   Probe.messageID = 'uuid:'+ getUUID(); 
   String message = buildProbeMessage(Probe.messageID );
   sendMulticast("239.255.255.250",3702, message , (messageRecivied){
    probeData.add(messageRecivied);});
       Probe.netHandle.listen((inComingProbe){
        if(inComingProbe != ""){
          readResponse(inComingProbe);
            probeMatchData.probeMatches.listen((inComingProbeMatch) async{
                if(inComingProbeMatch.xAddrs[0] !=""){
                  removeFreeProbeMatches(probeMatchList);
                if(!inlist(probeMatchList,inComingProbeMatch)){
                  probeMatchList.add(inComingProbeMatch); 
                  OnvifDevice onvifDev = await processMatch(inComingProbeMatch);
                  onDone(onvifDev);
                }
              }
          });
        }
     });
  }

  Future<OnvifDevice> _updateCapabilities(String username , String password , OnvifDevice device )async{
    String message = buildGetDeviceInformationMessage(device , username , password); 
    String information  = await httpPost(device.xAddr, message);
    Map<String, String> deviceInformation = parseGetDeviceInformation(information);
    device.serial = deviceInformation['serialNumber'];
    device.model = deviceInformation['model'];
    message = buildGetCapabilitiesMessage(device, username, password, "All");
    information = await httpPost(device.xAddr, message);
    Map<String,String> capablities = parseGetCapabilities(information);
    device.xAddr = capablities['XAddr'];
    device.eventsXAddr = capablities['Events'];
    device.mediaXAddr = capablities['Media'];
    return device;
  }

  Future<String>getCameraUri(OnvifDevice device , String username , String password)async{
      device = await _updateCapabilities(username, password, device);
       List<NetworkProtocol> networkProtocols = await  _getNetworkProtocols(device , username , password);
       for(NetworkProtocol networkProtocol in networkProtocols){
         if (networkProtocol.name == "HTTPS"){
            networkProtocol.enabled = true;
            networkProtocol.port = 443;
      }
     }
    String message = buildGetProfilesMessages(device, username, password);
    String profiles = await httpPost(device.mediaXAddr, message);
    List<String> profileList = parseGetProfiles(profiles);
    String targetProfileToken = profileList.last;
    Map<String , String> streamSetup = <String,String>{};
    streamSetup["stream"] = "RTP-Unicast";
    streamSetup["protocol"] ="HTTP";
    streamSetup["tunnel"] = null;
    message = buildGetStreamUriMessage(device , username , password, streamSetup, targetProfileToken);
    String result = await httpPost(device.mediaXAddr, message);
    return parseGetMediaUri(result);

    }

    Future<List<NetworkProtocol>> _getNetworkProtocols(OnvifDevice device , String username , String password)async{
      String message = buildGetNetworkProtocolsMessage(device, username , password);
      final info = await httpPost(device.xAddr, message);
      return parseGetNetworkProtocols(info);
    }
    
}
