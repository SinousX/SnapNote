import 'package:flutter/material.dart';
import 'package:snap_note/screens/edit_note_screen.dart';
import 'package:snap_note/screens/new_note_screen.dart';
import 'package:snap_note/screens/note_screen.dart';
import 'package:snap_note/screens/notes_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case NotesScreen.tag:
        return MaterialPageRoute(
          builder: (_) => NotesScreen(),
        );
      case NewNoteScreen.tag:
        return MaterialPageRoute(
          builder: (_) => NewNoteScreen(),
        );
      case NoteScreen.tag:
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => NoteScreen(noteIndex: args),
          );
        }
        return MaterialPageRoute(
          builder: (_) => NoteScreen(noteIndex: 0),
        );
      case EditNoteScreen.tag:
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => EditNoteScreen(noteIndex: args),
          );
        }
        return MaterialPageRoute(
          builder: (_) => EditNoteScreen(noteIndex: 0),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => NotesScreen(),
        );
    }
  }
}
