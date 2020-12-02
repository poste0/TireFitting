import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tire_fitting/data/Entity.dart';

abstract class Repository<T extends Entity>{
  Database db;
  String name;

  Repository.withName(String name){
    this.name = name;
    initDb().then((value){db = value; print('initDb');});
  }

  Repository(){
    initDb().then((value){db = value; db.rawQuery('SELECT name FROM sqlite_master WHERE type=\'table\'').then((value) => print(value));});
  }

  void add(T entity) async{
    Database database = await db;
    database.insert(name, entity.toMap());
  }

  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'tire_fitting.db');

    return openDatabase(
    path,
        onCreate: (db, version){
          db.execute('CREATE TABLE servicePoint (id TEXT PRIMARY KEY, address TEXT, countOfStuff INTEGER)');
          db.execute(
              'CREATE TABLE request (id TEXT PRIMARY KEY, requestType TEXT, wheelRadius INTEGER, time DATE, servicePointId TEXT, FOREIGN KEY (servicePointId) REFERENCES servicePoint(id))');

        },
        version: 2
    );
  }

  static void deleteDb() async {
    final path = join(await getDatabasesPath(), 'tire_fitting.db');

    deleteDatabase(path);
  }

  Future<List<T>> getAll();

  T get(int index){
    List<T> entities = [];
    getAll().then((value) => entities = value);
    if(index >= entities.length){
      throw new Exception("Index is wrong");
    }

    return entities[index];
  }

  void remove(T entity) async{
    final Database database = await db;
    database.delete(name, where: 'id = ?', whereArgs: [entity.id]);
  }

  int getSize(){
    List<T> entities;
    getAll().then((value) => entities = value);

    return entities.length;
  }

  Future<T> getById(String id);

}