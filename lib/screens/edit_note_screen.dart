import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:snap_note/elements/navigation_button.dart';
import 'package:snap_note/models/note.dart';
import 'package:snap_note/models/notes.dart';
import 'package:snap_note/screens/note_screen.dart';
import 'package:snap_note/screens/notes_screen.dart';
import 'package:snap_note/util/constants.dart';
import 'package:snap_note/util/database.dart';

class EditNoteScreen extends StatefulWidget {
  static const String tag = "/editNote";

  final int noteIndex;

  EditNoteScreen({@required this.noteIndex});

  @override
  State<StatefulWidget> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  bool _isTitleEmptyOrNull = false;

  bool _isTitleEmpty() {
    return _titleController?.text?.trim()?.isEmpty ?? true;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _textController.dispose();
  }

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
                          Navigator.of(context).pop();
                        },
                        iconSize: 23.0,
                        icon: Icon(Icons.arrow_back_ios_rounded),
                      ),
                    ),
                    _updateButtons(),
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
                          TextField(
                            controller: _titleController..text = snapshot.data.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Title",
                              hintStyle: TextStyle(color: kHintTextColor, fontSize: 35.0, fontWeight: FontWeight.w600),
                              errorText: _isTitleEmptyOrNull ? "Title can't be empty" : null,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: _textController..text = snapshot.data.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type something...",
                              hintStyle: TextStyle(color: kHintTextColor, fontSize: 20.0),
                            ),
                            textCapitalization: TextCapitalization.sentences,
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

  Widget _updateButtons() {
    return Row(
      children: [
        NavigationButton(
          button: IconButton(
            onPressed: () {
              deleteAlert(context);
            },
            iconSize: 30.0,
            icon: Icon(Icons.delete_forever),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        NavigationButton(
          button: FlatButton(
            onPressed: () {
              setState(() {
                _isTitleEmpty() ? _isTitleEmptyOrNull = true : _isTitleEmptyOrNull = false;
              });
              if (!_isTitleEmptyOrNull) {
                Note editedNote = Note(
                    id: widget.noteIndex,
                    title: _titleController.text,
                    text: _textController.text,
                    date: DateTime.now().toIso8601String());
                Notes().updateNote(editedNote);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(NoteScreen.tag, (route) => false, arguments: widget.noteIndex);
              }
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  deleteAlert(BuildContext context) {
    Alert(
      context: context,
      title: "Are you sure you want to delete the note?",
      type: AlertType.warning,
      style: kAlertStyle,
      buttons: [
        DialogButton(
          child: Text("CANCEL", style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
          color: Colors.blue,
        ),
        DialogButton(
          child: Text("DELETE", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Notes().deleteNote(widget.noteIndex);
            Navigator.of(context).pushNamedAndRemoveUntil(NotesScreen.tag, (Route<dynamic> route) => false);
            setState(() {});
          },
          color: Colors.red,
        ),
      ],
    ).show();
  }
}
