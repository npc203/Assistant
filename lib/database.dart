import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task {
  int _id;
  String _task;
  String _description;
  String _time; //DateTime.now()
  String _ping;

  Task(this._task, this._ping, this._time, [this._description]);
  Task.withId(this._id, this._task, this._ping, this._time,
      [this._description]); //Named Constructor

  //GETTERS
  int get id => _id;
  String get task => _task;
  String get description => _description;
  String get time => _time;
  String get ping => _ping;

  //SETTERS
  set task(String newTask) {
    //Add some validation layer here maybe?
    this._task = newTask;
  }

  set description(String newDesc) {
    this._description = newDesc;
  }

  set ping(String newPing) {
    this._ping = newPing;
  }

  set time(String newTime) {
    this._time = newTime;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['task'] = _task;
    map['ping'] = _ping;
    map['description'] = _description;
    map['time'] = _time;
    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._description = map['description'];
    this._task = map['task'];
    this._ping = map['ping'];
    this._time = map['time'];
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
    print("PATH:${await getDatabasesPath()}");
    return await openDatabase(join(await getDatabasesPath(), 'tasks.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $taskTable($colId INTEGER AUTO_INCREMENT PRIMARY KEY,$colTask TEXT, $colPing TEXT, $colDescription TEXT,$colTime TEXT)");
    });
  }

  Future<List<Map<String, dynamic>>> getTasksMapList() async {
    Database db = await this.database;
    //var result = db.rawQuery("SELECT * FROM $taskTable");
    var result = db.query(taskTable);
    return result;
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
    int result = await db.rawDelete("DELTE FROM $taskTable WHERE $colId=$id");
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
