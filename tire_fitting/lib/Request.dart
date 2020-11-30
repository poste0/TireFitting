import 'package:sqflite/sqflite.dart';
import 'package:tire_fitting/RequestType.dart';
import 'package:tire_fitting/ServicePoint.dart';

import 'Repository.dart';
import 'ServicePointRepository.dart';

class Request extends Entity{
  RequestType requestType;
  int wheelRadius;
  DateTime time;
  ServicePoint servicePoint;

  String name = 'Request';

  Request({
    this.requestType,
    this.wheelRadius,
    this.time,
    this.servicePoint
  });

  Request.withId(String id, RequestType requestType, int wheelRadius, DateTime time, ServicePoint servicePoint){
    this.id = id;
    this.requestType = requestType;
    this.wheelRadius = wheelRadius;
    this.time = time;
    this.servicePoint = servicePoint;
  }

  DateTime endTime(){
    return time.add(Duration(seconds: requestType.getDuration(wheelRadius).round()));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestType': requestType.name,
      'time': time.toString(),
      'servicePointId': servicePoint.id,
      'wheelRadius': wheelRadius
    };
  }

  static Future<List<Request>> fromMap(List<Map<String, dynamic>> map) async{
    List<ServicePoint> servicePoints = [];
    List<Future<ServicePoint>> asyncServicePoint = map.map((e) => ServicePointRepository().getById(e['servicePointId'])).toList();
    for(Future<ServicePoint> f in asyncServicePoint){
      ServicePoint servicePoint = await f;
      servicePoints.add(servicePoint);
    }
    return Future.sync(() => List.generate(map.length, (index) => Request.withId(
        map[index]['id'],
        RequestType.getRequestType(map[index]['requestType']),
        map[index]['wheelRadius'],
        DateTime.parse(map[index]['time']),
        servicePoints[index]
    )));
  }
}