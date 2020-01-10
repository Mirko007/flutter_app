import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "LoyaltyDatabase.db";
  static final _databaseVersion = 2;

  static final table = 'messages';

  static final columnId = '_id';
  static final columnIdMessage = 'id_message';
  static final columnCreated = 'created';
  static final columnTitle = 'title';
  static final columnMessage = 'message';
  static final columnReadStatus = 'read_status';
  static final columnDeleted = 'deleted';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnIdMessage TEXT NOT NULL,
            $columnCreated TEXT NOT NULL,
            $columnTitle TEXT NOT NULL,
            $columnMessage TEXT NOT NULL,
            $columnDeleted TEXT NOT NULL,
            $columnReadStatus INTEGER NOT NULL
          )
          ''');
  }
  // SQL code to create the database table
//  Future _onCreate(Database db, int version) async {
//    await db.execute('''
//          CREATE TABLE $table (
//            $columnId INTEGER PRIMARY KEY,
//            $columnCreated TEXT NOT NULL,
//            $columnTitle TEXT NOT NULL,
//            $columnMessage TEXT NOT NULL,
//            $columnReadStatus INTEGER NOT NULL
//          )
//          ''');
//  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
  //  return await db.query(table);
    return await db.rawQuery("SELECT * FROM $table order by $columnId DESC");
  }


//  Future<List<Map<String, dynamic>>> queryAllRowsDesc(String deleted) async {
//    Database db = await instance.database;
//
//    return await db.rawQuery('SELECT * FROM `messages` ORDER BY id_message DESC', [''] );
//
//  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCountRead() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE read_status = 0'));
  }

//  Future<List<Map<String, dynamic>>> queryAllRowsWhereDeleted(String deleted) async {
//    Database db = await instance.database;
//    return await db.rawQuery('SELECT * FROM `messages` WHERE NOT deleted =? ORDER BY id_message DESC', [''] );
//  }

  Future<List<Map<String, dynamic>>> updateReadStatus(int _id,int read_status) async {
    Database db = await instance.database;
    return await db.rawQuery("UPDATE `messages` SET read_status=$read_status WHERE _id = $_id");
  }

//  Future<List<Map<String, dynamic>>> updateDeleted(String id_message,String deleted) async {
//    Database db = await instance.database;
//    return await db.rawQuery(
//        "UPDATE `messages` SET deleted=$deleted WHERE id_message = $id_message");
//  }

//  Future<int> queryMessageExists(String id_message) async {
//    Database db = await instance.database;
//    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_message) FROM `messages` WHERE id_message = $id_message"));
//  }

//  Future<int> queryReadMessageExists() async {
//    Database db = await instance.database;
//    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_message) FROM `messages` WHERE read_status < 1"));
//  }
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String id = row[columnIdMessage];
    return await db.update(table, row, where: '$columnIdMessage = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}