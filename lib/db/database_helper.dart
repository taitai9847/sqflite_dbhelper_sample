import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_sample/models/sample.dart';
import 'package:sqflite_sample/models/table_fields.dart';

class DatabaseHelper {
  static final _databaseName = 'sample.db';
  static final _databaseVersion = 1;
  static final tableName = 'sample';

  DatabaseHelper.init();
  static final DatabaseHelper instance = DatabaseHelper.init();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // dbの削除(開発中は記述しておいたほうが良い)
    await deleteDatabase(path);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {

    //keyはAUTOINCREMENTにすることでよしなに付与してくれる
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
        CREATE TABLE $tableName (
          ${TableFields.id} $idType,
          ${TableFields.title} $textType
        )
        ''');
  }

  Future<Sample> create(Sample sample) async {
    final db = await instance.database;
    final id = await db!.insert(tableName, sample.toJson());
    print('create success!');
    return sample.copy(id: id);
  }

  Future<Sample> read(int id) async {
    final db = await instance.database;
    print('read success!');
    final maps = await db!.query(tableName,
        columns: TableFields.values,
        where: '${TableFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Sample.fromJson(maps.first);
    } else {
      throw Exception('ID: $id is not found');
    }
  }

  Future<int> update(Sample sample) async {
    final db = await instance.database;
    print('update success!');
    return db!.update(tableName, sample.toJson(),
        where: '${TableFields.id} = ?', whereArgs: [sample.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    print('delete success!');
    return await db!.delete(
      tableName,
      where: '${TableFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    print('db close!');
    db!.close();
  }
}
