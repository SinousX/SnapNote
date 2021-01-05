import 'package:flutter/material.dart';
import 'package:snap_note/elements/navigation_button.dart';
import 'package:snap_note/models/notes.dart';
import 'package:snap_note/util/constants.dart';

import 'notes_screen.dart';

class NewNoteScreen extends StatefulWidget {
  static const String tag = "/newNote";

  @override
  State<StatefulWidget> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  String _title;
  String _text;

  bool _isTitleEmptyOrNull() {
    return _title?.trim()?.isEmpty ?? true;
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
                    _saveButton(_isTitleEmptyOrNull()),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(),
              ),
              Expanded(
                flex: 87,
                child: ListView(
                  children: [
                    TextField(
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
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (text) {
                        setState(() {
                          _title = text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
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
                      onChanged: (text) {
                        setState(() {
                          _text = text;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveButton(bool isTitleEmptyOrNull) {
    return NavigationButton(
      isDisabled: isTitleEmptyOrNull,
      button: FlatButton(
        onPressed: isTitleEmptyOrNull
            ? null
            : () {
                Notes().addNote(_title, _text);
                Navigator.of(context).pushNamedAndRemoveUntil(NotesScreen.tag, (route) => false);
              },
        child: Text(
          "Save",
          style: TextStyle(
            color: isTitleEmptyOrNull ? Colors.grey : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
