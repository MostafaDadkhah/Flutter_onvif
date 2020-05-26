

import 'package:onvif/Repository/SendData.dart';
import 'package:onvif/Repository/buildMessages.dart';

class OnvifDevice{
  String xAddr ;
  DateTime timeOffset;
  String model ; 
  String serial;
  String eventsXAddr;
  String mediaXAddr;

   Future<String> getSystemDateAndTime({String xaddr})async{
        final String message = buildGetSystemDateAndTimeMessage();
        return await httpPost((xAddr)??xaddr, message );
  }
  
}