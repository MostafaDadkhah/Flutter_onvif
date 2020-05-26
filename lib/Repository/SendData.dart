import 'dart:io';

import 'package:dio/dio.dart';

sendMulticast(String ip , int port ,String message , Function (String)onDone){
    RawDatagramSocket.bind(ip, port).then((RawDatagramSocket socket){
    InternetAddress multicastAddress = new InternetAddress(ip);
    int multicastPort = port;
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0 , reuseAddress: false , reusePort: false).then((RawDatagramSocket s) {
      s.send(message.codeUnits, multicastAddress, multicastPort);
     
      s.listen((RawSocketEvent e){
        Datagram d = s.receive();
        if (d == null) return  ;
        String messageRecived = new String.fromCharCodes(d.data);
         onDone(messageRecived.trim()); 
      });
    });
  });
  }
  Future<String> httpPost(String url , String message)async{
  Response response;
  Dio dio = Dio();
  try{
  response = await dio.post(url , data: message);
  }catch (e){
    return e.error.source.toString();
  }
   return response.data.toString();
}