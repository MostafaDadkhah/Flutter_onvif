import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onvif/Model/OnvifDevice.dart';
import 'package:onvif/onvif.dart';

import 'VideoPlayer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<OnvifDevice> devices = [];
  StreamController<List<OnvifDevice>> streamDevicesController = StreamController() ;
  List<TextEditingController>usernameController=[];
  List<TextEditingController>passwordController=[];
  List<FocusNode>usernameFocus=[];
  List<FocusNode>passwordFocus=[];
   ONVIF onvif = ONVIF();
@override
  void initState() {
 
  onvif.getDevices((device){
  devices.add(device);
  streamDevicesController.add(devices);
  usernameController.add(TextEditingController());
  passwordController.add(TextEditingController());
  usernameFocus.add(FocusNode());
  passwordFocus.add(FocusNode());
  });
  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
       body: StreamBuilder(
        stream: streamDevicesController.stream,
        builder: (BuildContext context , AsyncSnapshot<List<OnvifDevice>>snapshot){
          List<OnvifDevice> data = (snapshot.data)??[];
          return GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
           itemCount: data.length,
           itemBuilder: (BuildContext context  , int index){
            return  Card(child: 
                    Column(children: <Widget>[
                      TextField(
                        controller: usernameController[index],
                        decoration: InputDecoration(
                          hintText: "Username"
                        ),
                        focusNode: usernameFocus[index],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (value){
                          _fieldFocusChange(context, usernameFocus[index], passwordFocus[index]);
                        },
                      ), 
                       TextField(
                        controller: passwordController[index],
                        decoration: InputDecoration(
                          hintText: "Password"
                        ),
                        focusNode: passwordFocus[index],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value){
                          connect(data[index] , usernameController[index].text , passwordController[index].text );
                        },
                      ), 
                      RaisedButton(child: Text("connect"),
                      onPressed: (){
                        connect(data[index] , usernameController[index].text , passwordController[index].text );
                      },), 
                      SizedBox(height: 20,),
                      Text(showIP(data[index])),
                      
                    ],), );
           });
        },
      ),
      );
  }
  void _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus); 
}
String showIP(OnvifDevice device){
  return device.xAddr.split('/')[2];
}
void connect(OnvifDevice onvifDev  , String username , String password)async{

              String uri = await onvif.getCameraUri(onvifDev, username, password);
               Navigator.push(context,
               MaterialPageRoute(
             builder: (context) => VideoPlayer(uri , username , password),));
    } 
}

