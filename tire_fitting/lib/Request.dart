import 'package:tire_fitting/RequestType.dart';
import 'package:tire_fitting/ServicePoint.dart';

class Request{
  RequestType requestType;
  int wheelRadius;
  DateTime time;
  ServicePoint servicePoint;

  Request([
    this.requestType,
    this.wheelRadius,
    this.time,
    this.servicePoint
  ]);

  DateTime endTime(){
    return time.add(Duration(seconds: requestType.getDuration(wheelRadius).round()));
  }
}