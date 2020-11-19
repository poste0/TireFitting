import 'package:tire_fitting/ServicePoint.dart';

class ServicePointRepository{
  static final ServicePointRepository _repository = ServicePointRepository._internal();

  factory ServicePointRepository(){
    return _repository;
  }

  ServicePointRepository._internal();

  List<ServicePoint> servicePoints = [];

  bool addServicePoint(ServicePoint servicePoint){
    try{
      servicePoints.add(servicePoint);
      return true;
    }
    catch(e){
      return false;
    }
  }

  List<ServicePoint> getAll(){
    return servicePoints;
  }

  ServicePoint get(int index){
    if(index >= servicePoints.length){
      throw new Exception("Index is wrong");
    }
    return servicePoints[index];
  }

  bool removeServicePoint(ServicePoint servicePoint){
    try{
      servicePoints.remove(servicePoint);
      return true;
    }
    catch(e){
      return false;
    }
  }

  int getSize(){
    return servicePoints.length;
  }
}