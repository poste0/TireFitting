import 'package:tire_fitting/TireDismount.dart';

abstract class RequestType{
  String name;
  double getDuration(int radius);

  static final List<RequestType> requestTypes = [TireDismount()];

  static RequestType getRequestType(String name){
    List<RequestType> requestTypesResult = requestTypes.where((element) => element.name == name).toList();
    if(requestTypesResult.length != 1){
      throw Error();
    }

    return requestTypesResult.first;
  }
}