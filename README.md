# ONVIF
<img src="http://mostafadadkhah.ir/images/CCTV.png)" height="200" />
This package is designed to find CCTV cameras that support the ONVIF protocol. The method for finding these cameras is the [WS-Discovery](https://en.wikipedia.org/wiki/WS-Discovery) protocol.

## How to use

```dart
import  'package:onvif/Model/OnvifDevice.dart';
import  'package:onvif/onvif.dart';
```
Create an ONVIF object and call the get Devices method.

```dart
List<OnvifDevice> devices = [];
ONVIF onvif = ONVIF();
onvif.getDevices((device){
devices.add(device);
});
```
To get the streaming link , all you have to do is call the getCameraUri function and send the username and password values of the camera you specified as an argument.
```dart 
String uri = await onvif.getCameraUri(onvifDev, username, password);
```
You can play the resulting url with the vlc player. Note that to play the contents of the camera, you must change the resulting url to the following pattern.
```dart
uri.substring(0 , 7)+ "$username:$password@"+ url.substring(7 , url.length)
```
See the example project for a better understanding.
