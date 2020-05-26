import 'package:collection/collection.dart';
import 'package:onvif/Model/ProbeMatch.dart';

String removePranteces(String s){
  s= s.replaceAll( "(", "");
  return s.replaceAll(")", "");
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
List<String>removeFreeProfileAttributes(List<String> profileAttributes){
  String s ;
 
  for( int i=0 ; i< profileAttributes.length ; i ++ ){
  
      s= profileAttributes[i];
      s = s.replaceAll("[", "");
      s = s.replaceAll("]", "");
      s = s.replaceAll("fixed=", "");
      s = s.replaceAll('"true"', "");
      s = s.replaceAll('"false"', "");
      s = s.replaceAll(",", "");
      s = s.replaceAll("]", "");
      s = s.replaceAll("token=", "");
       s = s.replaceAll('"', "");
        s = s.replaceAll(" ", "");
      profileAttributes[i] = s;
    }
    List<String> newList = [];
     for (int i = 0 ; i<= profileAttributes.length ; i++)
      if(i%2 != 0)newList.add(profileAttributes[i]);
    return newList;
}