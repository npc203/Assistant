import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task {
  int id;
  String task;
  String description;
  String time; //DateTime.now()
  String ping;

  Task({this.task, this.ping, this.time, this.description});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = id;
    map['task'] = task;
    map['ping'] = ping;
    map['description'] = description;
    map['time'] = time;
    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    description = map['description'];
    task = map['task'];
    ping = map['ping'];
    time = map['time'];
  }
}

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String taskTable = 'Tasks';
  String colId = 'id';
  String colTask = 'task';
  String colPing = 'ping';
  String colTime = 'time';
  String colDescription = 'description';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDB();
    }
    return _database;
  }

  Future<Database> initializeDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'tasks.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY,$colTask TEXT, $colPing TEXT, $colDescription TEXT,$colTime TEXT)");
    });
  }

  Future<List<Task>> fetchTasks() async {
    Database db = await database;
    List<Map> result = await db.query(taskTable);
    return result.length == 0
        ? []
        : result.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.database;
    var result = db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.database;
    var result = db.update(taskTable, task.toMap(),
        where: '$colId=?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete("DELETE FROM $taskTable WHERE $colId=$id");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $taskTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
