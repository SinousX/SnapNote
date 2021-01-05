import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:snap_note/elements/navigation_button.dart';
import 'package:snap_note/models/note.dart';
import 'package:snap_note/screens/edit_note_screen.dart';
import 'package:snap_note/screens/notes_screen.dart';
import 'package:snap_note/util/database.dart';

class NoteScreen extends StatefulWidget {
  static const String tag = "/note";

  final int noteIndex;

  NoteScreen({@required this.noteIndex});

  @override
  State<StatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0),
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NavigationButton(
                      button: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(NotesScreen.tag, (route) => false);
                        },
                        iconSize: 23.0,
                        icon: Icon(Icons.arrow_back_ios_rounded),
                      ),
                    ),
                    NavigationButton(
                      button: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(EditNoteScreen.tag, arguments: widget.noteIndex);
                        },
                        iconSize: 23.0,
                        icon: Icon(Icons.edit_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(),
              ),
              FutureBuilder<Note>(
                future: DBProvider.db.getNote(widget.noteIndex),
                builder: (BuildContext context, AsyncSnapshot<Note> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      flex: 87,
                      child: ListView(
                        children: [
                          Text(
                            snapshot.data.title,
                            style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w600),
                            maxLines: null,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            DateFormat.yMMMd("en_US").format(DateTime.parse(snapshot.data.date)),
                            style: TextStyle(
                              fontSize: 21.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            snapshot.data.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            maxLines: null,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                      flex: 90,
                      child: Container(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
