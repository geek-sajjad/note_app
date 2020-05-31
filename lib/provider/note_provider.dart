import 'package:flutter/material.dart';
import 'package:note/models/note.dart';
import 'package:note/services/database_service.dart';
import 'package:uuid/uuid.dart';

class NoteProvider with ChangeNotifier {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Note> _notes = [];


  set setNotes (List<Note> notes) => _notes = notes;
  List<Note> get notes => _notes;


  // Future<List<Note>> get notes async {
  //   return await _databaseHelper.getNotes();
  // }

  Future<void> loadNotes() async {
    _notes = await _databaseHelper.getNotes();
  }

  // Future<Note> findNote(int id) async {
  //   return _notes.where((n) => n.id ==id).first;
  // }

  void addNote({String title, String body}) async{
    final note = Note(
      title: title,
      body: body,
    );
    _notes.add(note);
    note.id = await _databaseHelper.insert(body: body, title: title);
    // notifyListeners();
  }

  void deleteNote(int id) {
    var n = _notes.firstWhere((n) => id == n.id);
    _notes.remove(n);
    _databaseHelper.deleteNote(id);
    // notifyListeners();
  }

  void editNote({int id, String title, String body}) {
    var n = _notes.firstWhere((n) => id == n.id);
    n.title = title;
    n.body = body;
    _databaseHelper.updateNote(id: id, title: title, body: body);
    // notifyListeners();
  }
}
