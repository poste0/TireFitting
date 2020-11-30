import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tire_fitting/Repository.dart';
import 'package:tire_fitting/ServicePoint.dart';

import 'Request.dart';

class RequestRepository extends Repository<Request>{
  static final RequestRepository _repository = RequestRepository._internal();

  final String name = Request().name;

  factory RequestRepository(){
    return _repository;
  }

  RequestRepository._internal();

  Future<List<Request>> getRequests(ServicePoint servicePoint) async{
    List<Request> requests = await getAll();

    return requests.where((element) => element.servicePoint == servicePoint).toList();
  }

  Future<bool> addRequest(Request request) async{
    int workers = request.servicePoint.countOfStuff;
    List<Request> requests = await getRequests(request.servicePoint);
    print('add');
    int busyWorkers = requests.where((element) => isBusy(element, request)).length;
    print(workers);
    print(busyWorkers);

    if(workers - busyWorkers <= 0){
      return false;
    }
    else{
      try{
        add(request);
        return true;
      }
      catch(e){
        return false;
      }
    }
  }

  bool isBusy(Request request, Request addedRequest){
    return (addedRequest.time.isAfter(request.time) && addedRequest.time.isBefore(request.endTime())) ||
        (addedRequest.endTime().isAfter(request.time) && addedRequest.endTime().isBefore(request.endTime())) ||
        (addedRequest.time == request.time && addedRequest.endTime() == request.endTime());
  }

  Future<Request> getById(String id) async{
    Database database = await db;
    List<Map<String, dynamic>> maps = await database.query(name, where: 'id = ?', whereArgs: [id]);

    List<Request> requests = await Request.fromMap(maps);
    return requests[0];
  }

  @override
  Future<List<Request>> getAll() async {
    Database database = db;
    List<Map<String, dynamic>> maps = await database.query(name);

    print('maps');
    print(maps);

    return Request.fromMap(maps);
  }

}