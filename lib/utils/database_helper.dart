import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:database_intro/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableUser = "userTable";
  final String columnID = "id";
  final String columnUsername = "username";
  final String columnPassword = "password";


  static Database _db;

  Future<Database> get db async{

    if(_db != null){
      return _db;
    }

    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,"maindb.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  /*
     id | Username | Password
     ------------------------
     1 | Muhammad Arslan Nasr | HelloWorld
     2 | Malik Hassan Rauf Khan Awan | HelloWorld
   */

   void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tableUser($columnID INTEGER PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT)");
  }

  //CRUD - CREATE, READ, UPDATE, DELETE
  //INSERTION
  Future<int> saveUser(User user) async{
     var dbClient = await db;
     int res = await dbClient.insert('$tableUser', user.toMap());
     return res;
  }

  //Get Users
  Future<List> getAllUsers() async{
     var dbClient = await db;
     var result = await dbClient.rawQuery("SELECT * FROM $tableUser");
     return result.toList();
  }

  //Get Count
  Future<int> getCount() async{
     var dbClient = await db;
     return Sqflite.firstIntValue(
       await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser"));
  }

  //Get Data based on ID
  Future<User> getUser(int id) async{
     var dbClient = await db;
     var result = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $columnID = $id");
     if(result.length == 0) return null;
     return new User.fromMap(result.first);
  }

  //Delete User based on ID
  Future<int> deleteUser(int id) async{
     var dbClient = await db;
     return await dbClient.delete(tableUser,
       where: "$columnID = ?", whereArgs: [id]);
  }

  //Update User Data based on ID
  Future<int> updateUser(User user) async{
     var dbClient = await db;
     return await dbClient.update(tableUser, user.toMap(), where: "$columnID = ?",whereArgs: [user.id]);
  }

  //Close Database
  Future close() async{
     var dbClient = await db;
     return dbClient.close();
  }

}
