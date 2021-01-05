import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:snap_note/models/note.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final _dbName = "Notes.db";
  static final _dbVersion = 1;

  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("""
        CREATE TABLE Note (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          text TEXT NOT NULL,
          date TEXT NOT NULL
        )
        """);
    });
  }

  newNote(Note note) async {
    final db = await database;
    var res = await db.insert("Note", note.toMap());
    return res;
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    var res = await db.query("Note", orderBy: "DATE DESC");
    List<Note> list = res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
    return list;
  }

  Future<Note> getNote(int id) async {
    final db = await database;
    var res = await db.query("Note", where: "id = ?", whereArgs: [id]);
    List<Note> list = res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
    Note note = list[0];
    return note;
  }

  Future<List<Note>> getNotes(String title) async {
    final db = await database;
    var res = await db.query("Note", where: "title LIKE ?", whereArgs: ["%$title%"], orderBy: "DATE DESC");
    List<Note> list = res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
    return list;
  }

  updateNote(Note note) async {
    final db = await database;
    var res = await db.update("Note", note.toMap(), where: "id = ?", whereArgs: [note.id]);
    return res;
  }

  deleteNote(int id) async {
    final db = await database;
    var res = await db.delete("Note", where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<int> getNotesLength() async {
    final db = await database;
    var x = await db.rawQuery("SELECT COUNT (*) FROM Note");
    int count = Sqflite.firstIntValue(x);
    return count;
  }
}
