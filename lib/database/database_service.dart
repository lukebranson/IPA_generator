import 'dart:io';
import 'package:path/path.dart';
import 'package:slp_notebook/database/slp_notebook_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//amazing yt video for this stuff: https://www.youtube.com/watch?v=9kbt4SBKhm0&t=247s

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if(Platform.isWindows || Platform.isLinux){
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name='slp-notebook.db';
    final path = await getDatabasesPath();
    return join(path,name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var exists = await databaseExists(path);
    if(!exists){
      await Directory(await getDatabasesPath()).create(recursive: true);
    }
    var database = await openDatabase(path,version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version) async {
    await SlpNotebookDb().createTables(database);
  }
  
}