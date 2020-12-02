import 'package:tire_fitting/data/Entity.dart';

class ServicePoint extends Entity{
  String address;
  int countOfStuff;

  @override
  String name = 'servicePoint';

  ServicePoint({this.address, this.countOfStuff});

  ServicePoint.withId(String id, String address, int countOfStuff){
    this.id = id;
    this.address = address;
    this.countOfStuff = countOfStuff;
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'address': address,
      'countOfStuff': countOfStuff
    };
  }

  static List<ServicePoint> fromMap(List<Map<String, dynamic>> map){
    return List.generate(map.length, (index) => ServicePoint.withId(
        map[index]['id'],
        map[index]['address'],
        map[index]['countOfStuff']
    ));
  }

  @override
  bool operator ==(other){
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

}