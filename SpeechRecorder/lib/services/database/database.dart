import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../classes/user.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  late Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      create table $tableUsers ( 
        $columnId integer primary key autoincrement, 
        $columnName text not null)
      ''');
  }

  Future<int> searchIdByUser(String uname) async {
    var dbClient = await db;
    List<String> columnsToSelect = [
      columnId,
    ];
    String whereString = '$columnName= ?';
    List<dynamic> whereArguments = [uname];
    List<Map> result = await dbClient.query(
      tableUsers,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: whereArguments,
    );

    // print the results
    if (result.length == 1) {
      return result[0]['id'];
    }
    debugPrint("Query failed | Hits: " + result.length.toString());
    return -1;
  }

  Future<String> searchUserById(int uid) async {
    var dbClient = await db;
    List<String> columnsToSelect = [
      columnName,
    ];
    String whereString = '$columnId= ?';
    List<dynamic> whereArguments = [uid];
    List<Map> result = await dbClient.query(
      tableUsers,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: whereArguments,
    );

    // print the results
    if (result.length == 1) {
      return result[0]['name'];
    }
    debugPrint("Query failed | Hits: " + result.length.toString());
    return "XX2X";
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    return await dbClient.insert(tableUsers, user.toMap());
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(tableUsers, columns: [columnId, columnName]);
    List<User> users = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }
}
