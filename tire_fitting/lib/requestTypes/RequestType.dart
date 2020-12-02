import 'package:tire_fitting/requestTypes/ChangeWheel.dart';
import 'package:tire_fitting/requestTypes/RubberFix.dart';
import 'package:tire_fitting/requestTypes/TireDismount.dart';

abstract class RequestType{
  String name;
  double getDuration(int radius);

  static final List<RequestType> requestTypes = [TireDismount(), RubberFix(), ChangeWheel()];

  static RequestType getRequestType(String name){
    List<RequestType> requestTypesResult = requestTypes.where((element) => element.name == name).toList();
    if(requestTypesResult.length != 1){
      throw Error();
    }

    return requestTypesResult.first;
  }
}