import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tire_fitting/requestTypes/ChangeWheel.dart';
import 'package:tire_fitting/requestTypes/RubberFix.dart';
import 'package:tire_fitting/requestTypes/TireDismount.dart';

abstract class RequestType{
  String name;
  double getDuration(int radius);

  String getName(BuildContext context){
    return FlutterI18n.translate(context, name);
  }

  static final List<RequestType> requestTypes = [TireDismount(), RubberFix(), ChangeWheel()];

  static RequestType getRequestType(String name){
    List<RequestType> requestTypesResult = requestTypes.where((element) => element.name == name).toList();
    if(requestTypesResult.length != 1){
      throw Error();
    }

    return requestTypesResult.first;
  }
}