import 'package:onvif/Model/OnvifDevice.dart';
import 'package:onvif/Model/ProbeMatch.dart';
import 'package:rxdart/rxdart.dart';

ProbeBloc probeData = ProbeBloc();
ProbeMatchBloc probeMatchData = ProbeMatchBloc();
OnvifDeviceBLOC deviceBLOC = OnvifDeviceBLOC();

class ProbeBloc {
  String _probe ;
  BehaviorSubject <String> _subject = BehaviorSubject();
  Stream <String> get probes => _subject.stream;
  ProbeBloc(){
    _subject.add(_probe);
    _subject.sink.add("");
  }
  void add(String s){
    _subject.sink.add(s);
  }
}

class ProbeMatchBloc {
  ProbeMatch _probeMatchBloc ;
  BehaviorSubject <ProbeMatch> _subject = BehaviorSubject();
  Stream <ProbeMatch> get probeMatches => _subject.stream;
  ProbeMatchBloc(){
    _subject.add(_probeMatchBloc);
    _subject.sink.add(ProbeMatch([""],[""],[""],"",""));
  }
  void add(ProbeMatch s){
    _subject.sink.add(s);
  }

}

class OnvifDeviceBLOC{
  OnvifDevice _device;
  BehaviorSubject <OnvifDevice> _subject = BehaviorSubject();
  Stream<OnvifDevice> get devices => _subject.stream;
  OnvifDeviceBLOC(){
    _subject.add(_device);
    _subject.sink.add(OnvifDevice());
  }
  void add(OnvifDevice s){
    _subject.sink.add(s);
  }
}
