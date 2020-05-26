import 'package:onvif/Model/OnvifDevice.dart';
import 'package:onvif/Model/WsUsernameToken.dart';

String buildProbeMessage(String messageID ){
    return '<?xml version="1.0" encoding="UTF-8"?>\r\n'+
    '<e:Envelope xmlns:e="http://www.w3.org/2003/05/soap-envelope"\r\n'+
    'xmlns:w="http://schemas.xmlsoap.org/ws/2004/08/addressing"\r\n' +
    'xmlns:d="http://schemas.xmlsoap.org/ws/2005/04/discovery"\r\n' +
    'xmlns:dn="http://www.onvif.org/ver10/device/wsdl">\r\n'+ 
    '<e:Header>\r\n' +
    '<w:MessageID>uuid:$messageID</w:MessageID>\r\n' +
    '<w:To e:mustUnderstand="true">urn:schemas-xmlsoap-org:ws:2005:04:discovery</w:To>\r\n'+ 
    '<w:Action\r\n'+
    'a:mustUnderstand="true">http://schemas.xmlsoap.org/ws/2005/04/discovery/Probe</w:Action>\r\n'+
    '</e:Header>\r\n'+
    '<e:Body>\r\n'+
    '<d:Probe><d:Types>dn:NetworkVideoTransmitter</d:Types>\r\n'+
    '</d:Probe>\r\n'+
    '</e:Body>\r\n'+
    '</e:Envelope>\r\n';
   }
   String buildGetSystemDateAndTimeMessage(){
     return  '<?xml version="1.0" encoding="UTF-8"?>'+
        '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"'+
        'xmlns:tds="http://www.onvif.org/ver10/device/wsdl"> <SOAP-ENV:Body>'+
        '<tds:GetSystemDateAndTime/> </SOAP-ENV:Body>'+
        '</SOAP-ENV:Envelope>';
   }
  String buildGetDeviceInformationMessage(OnvifDevice device ,String username ,String password){
      return '<?xml version="1.0" encoding="UTF-8"?>'+
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"'+
            'xmlns:tds="http://www.onvif.org/ver10/device/wsdl">'+ 
            setAuthenticationInformation(device , username, password)+
            '<SOAP-ENV:Body> <tds:GetDeviceInformation/>'+
            '</SOAP-ENV:Body> </SOAP-ENV:Envelope>';
   }
   String buildGetCapabilitiesMessage(OnvifDevice device , String username , String password , String category){
      return  '<?xml version="1.0" encoding="UTF-8"?>'+
          '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"'+
          'xmlns:tds="http://www.onvif.org/ver10/device/wsdl">'+
          setAuthenticationInformation(device , username , password)+
          '<SOAP-ENV:Body><tds:GetCapabilities>'+
          '<tds:Category>$category</tds:Category>'+
          '</tds:GetCapabilities> </SOAP-ENV:Body>'+
          '</SOAP-ENV:Envelope>';
   }
   String setAuthenticationInformation(device , username , password){
       WsUsernameToken token = WsUsernameToken(username, password , device);
      return '<SOAP-ENV:Header><Security s:mustUnderstand="1" xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'+
      '<UsernameToken><Username>${token.username}</Username>'+
      '<Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">${token.password}</Password>'+
      '<Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">${token.nonce}</Nonce>'+
      '<Created xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">${token.created}</Created></UsernameToken></Security>'+
      '</SOAP-ENV:Header>';
   }
   String buildGetNetworkProtocolsMessage(OnvifDevice device , String username , String password){
      return '<?xml version="1.0" encoding="utf-8"?>'+
          '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:tt="http://www.onvif.org/ver10/schema">'+
          setAuthenticationInformation(device , username , password)+
          '<SOAP-ENV:Body><GetNetworkProtocols xmlns="http://www.onvif.org/ver10/device/wsdl" />'+
          '</SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
   }
   String buildGetProfilesMessages(OnvifDevice device , String username , String password){
     return '<?xml version="1.0" encoding="UTF-8"?>'+
          '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"'+
          'xmlns:trt="http://www.onvif.org/ver10/media/wsdl">'+
          setAuthenticationInformation(device , username , password) +
          '<SOAP-ENV:Body><trt:GetProfiles/></SOAP-ENV:Body></SOAP-ENV:Envelope>';
   }
   String buildGetStreamUriMessage(OnvifDevice device , String username , String password , Map<String,String> streamSetup,String targetProfileToken ){
     return '<?xml version="1.0" encoding="utf-8"?>'+
          '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"'+
          'xmlns:trt="http://www.onvif.org/ver10/media/wsdl" xmlns:tt="http://www.onvif.org/ver10/schema">'+
          setAuthenticationInformation(device , username , password)+
            '<SOAP-ENV:Body><trt:GetStreamUri>'+
          '<trt:StreamSetup> <tt:Stream>${streamSetup['stream']}</tt:Stream><tt:Transport>'+
          '<tt:Protocol>${streamSetup['protocol']}</tt:Protocol></tt:Transport></trt:StreamSetup>'+
          '<trt:ProfileToken>$targetProfileToken</trt:ProfileToken></trt:GetStreamUri>'+
          '</SOAP-ENV:Body></SOAP-ENV:Envelope>';
   }