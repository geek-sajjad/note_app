import 'dart:io';

import 'package:note/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // database table and column names
  final String tableNotes = 'notes';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnBody = 'body';

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableNotes (
                $columnId INTEGER PRIMARY KEY,
                $columnTitle TEXT NOT NULL,
                $columnBody TEXT
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert({String title, String body}) async {
    Database db = await database;
    int id = await db.insert(tableNotes, {'title' : title, 'body' : body});
    return id;
  }

  Future<List<Note>> getNotes() async {
    Database db = await database;

    // Query the table for all The Accounts.
    final List<Map<String, dynamic>> maps = await db.query(tableNotes);
    // print(maps);
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i][columnId],
        body: maps[i][columnBody],
        title: maps[i][columnTitle],
      );
    });
  }

  // clear() async {
  //   Database db = await database;
  //   return await db.delete(
  //     tableNotes,
  //   );
  // }

  Future<Note> getNote({int id}) async {
    assert(id != null);
    Database db = await database;
    List<Map> results = await db.query(
      tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
    // print(results);
    return Note.fromJson(results.first);
  }

  Future<int> updateNote({String title, String body, int id}) async {
    Database db = await database;
    // return await db.update(tableNotes, note.toMap());
    return await db.update(
        tableNotes, {'body': body, 'title': title},
        whereArgs: [id], where: '$columnId = ?');
  }

  Future<int> deleteNote(int id) async {
    Database db = await database;
    // List<Map> maps =
    //     await db.query(tableNotes, where: 'id = ?', whereArgs: [id]);

    return await db
        .delete(tableNotes, where: 'id = ?', whereArgs: [id]);
  }
}
