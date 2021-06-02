import 'package:collection/collection.dart';
import 'package:onvif/Model/ProbeMatch.dart';
import 'package:uuid/uuid.dart';

String getUUID(){
  return Uuid().v4();
}

void removeFreeProbeMatches(List<ProbeMatch> list){
   list.removeWhere((item)=>item.address == "");
}
void removeFreeScopes(List<String> list){
  list.removeWhere((item)=> item =="");
}
bool inlist(List<ProbeMatch> probeMatchlist,ProbeMatch probeMatch){
  Function eq = const ListEquality().equals;
  for(ProbeMatch _probeMatch in probeMatchlist)
  if (eq(_probeMatch.xAddrs , probeMatch.xAddrs))
  return true;
  return false;
}
String utcTime2DateTimeString(DateTime utcTimeDate){
  return "${utcTimeDate.year}-${utcTimeDate.month}-${utcTimeDate.day}T${utcTimeDate.hour}:${utcTimeDate.minute}:${utcTimeDate.second}Z";
}
