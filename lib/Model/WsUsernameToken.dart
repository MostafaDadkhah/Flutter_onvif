import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:nonce/nonce.dart';
import 'package:onvif/Repository/Utils.dart';
import 'OnvifDevice.dart';

class WsUsernameToken{
   String username ;
   String created ;
   String nonce;
   String password;
   OnvifDevice device;
   WsUsernameToken(this.username , this.password, this.device){
     List<int> nonceBinaryData = utf8.encode(Nonce.generate());
      String nonceBased64 = base64.encode(nonceBinaryData);
      this.nonce = nonceBased64;
       DateTime utcTimeDate = device.timeOffset;
      String utcTimeStringData = utcTime2DateTimeString(utcTimeDate);
      List<int> utcTimeBinaryData = utf8.encode(utcTimeStringData);
      this.created = utcTimeStringData;
      List<int> passwordBinaryData = utf8.encode(password);
      Digest passwordDigest = sha1.convert(nonceBinaryData + utcTimeBinaryData + passwordBinaryData);
      String  passwordDigestBase64 = base64.encode(passwordDigest.bytes);
      this.password = passwordDigestBase64;
   }
   
}