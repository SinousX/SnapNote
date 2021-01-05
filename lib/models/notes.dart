import 'package:snap_note/models/note.dart';
import 'package:snap_note/util/database.dart';

class Notes {
  void addNote(String title, String text) {
    DBProvider.db.newNote(
        Note(title: title, text: text?.trim()?.isEmpty ?? true ? "" : text, date: DateTime.now().toIso8601String()));
  }

  void updateNote(Note note) {
    DBProvider.db.updateNote(note);
  }

  void deleteNote(int id) {
    DBProvider.db.deleteNote(id);
  }

  void deleteSelectedNotes(List<int> ids) {
    for (int i = 0; i < ids.length; i++) {
      DBProvider.db.deleteNote(ids[i]);
    }
  }
}
