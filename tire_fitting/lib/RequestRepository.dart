import 'package:tire_fitting/ServicePoint.dart';

import 'Request.dart';

class RequestRepository{
  static final RequestRepository _repository = RequestRepository._internal();

  factory RequestRepository(){
    return _repository;
  }

  RequestRepository._internal();

  List<Request> requests = [];

  List<Request> getRequests(ServicePoint servicePoint){
    return requests.where((element) => element.servicePoint == servicePoint).toList();
  }

  bool addRequest(Request request){
    int workers = request.servicePoint.countOfStuff;
    int busyWorkers = getRequests(request.servicePoint).where((element) => isBusy(element, request)).length;

    if(workers - busyWorkers < 0){
      return false;
    }
    else{
      try{
        requests.add(request);
        return true;
      }
      catch(e){
        return false;
      }
    }
  }

  bool isBusy(Request request, Request addedRequest){
    return request.time.isBefore(addedRequest.time) && request.endTime().isAfter(addedRequest.time);
  }
}