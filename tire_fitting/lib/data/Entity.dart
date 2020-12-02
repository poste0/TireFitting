import 'package:uuid/uuid.dart';

abstract class Entity {
  String id = Uuid().v4();
  String name;

  Map<String, dynamic> toMap();

  static List<Entity> fromMap(List<Map<String, dynamic>> map){
    throw UnimplementedError();
  }
}