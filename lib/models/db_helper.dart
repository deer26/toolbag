import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final _databaseName = "TODOTable.db";
  static final _databaseVersion = 1;

  static final table = 'todo_table';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnDone = 'done';

  // singleton class yapalım
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  //  Tek taraftan kontrol edilebilsin
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // program ilk çalıştıgında bu işlem yavaş yürütülebilir
    _database = await _initDatabase();
    return _database;
  }

  // cihazda database olusmamıssa bunu çalıştırır
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL Code ile tablo yaratma işlemi
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDone INTEGER NOT NULL
          )
          ''');
  }
  // Helper methodları

  // tabloya satır ekler.Dönüşte Id'yi döner
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Tablodaki dataları döner
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // tablodaki satır sayısını döner
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // Update işlemi
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // silme işlemi
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
