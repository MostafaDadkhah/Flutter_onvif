import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer(this.url ,  this.username , this.password ,  {Key key}) : super(key: key);
  final String url;
  final String username ;
  final String password;
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}
VlcPlayerController controller ;
class _VideoPlayerState extends State<VideoPlayer> {
  String url ;
  @override
  void initState() {
    url = widget.url;
    controller = VlcPlayerController(onInit: (){controller.play();});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(appBar: AppBar(),body: Center(
       child: VlcPlayer(
            controller: controller, 
            aspectRatio: 16/9, 
            url:url.substring(0 , 7)+ "${widget.username}:${widget.password}@"+ url.substring(7 , url.length) ,
            placeholder: Center(child:CircularProgressIndicator()),

    ),
    ),);
    
  }
}