import 'package:sqflite/sqflite.dart';
import 'package:tire_fitting/data/Repository.dart';
import 'package:tire_fitting/data/RequestRepository.dart';
import 'package:tire_fitting/entity/ServicePoint.dart';

class ServicePointRepository extends Repository<ServicePoint>{
  static final ServicePointRepository _repository = ServicePointRepository._internal();

  final String name = ServicePoint().name;

  factory ServicePointRepository(){
    return _repository;
  }

  ServicePointRepository._internal();

  Future<List<ServicePoint>> getAll() async{
    db.rawQuery('SELECT name FROM sqlite_master WHERE type=\'table\'').then((value) => print('s' + value.toString()));
    db.query('request').then((value) => print(value));
    final Database database = await db;
    List<Map<String, dynamic>> maps = await database.query(name);

    print(maps.toString());

    return ServicePoint.fromMap(maps);
  }

  int getSize(){
    List<ServicePoint> servicePoints;
    getAll().then((value) => servicePoints = value);

    return servicePoints.length;
  }

  Future<ServicePoint> getById(String id) async{
    Database database = await db;
    List<Map<String, dynamic>> maps = await database.query(name, where: 'id = ?', whereArgs: [id]);

    print(id);
    print('a');

    return ServicePoint.fromMap(maps)[0];
  }

  void remove(ServicePoint entity) async{
    final Database database = await db;
    database.delete(RequestRepository().name, where: 'servicePointId = ?', whereArgs: [entity.id]);
    database.delete(name, where: 'id = ?', whereArgs: [entity.id]);
  }
}