import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:snap_note/elements/navigation_button.dart';
import 'package:snap_note/models/note.dart';
import 'package:snap_note/models/notes.dart';
import 'package:snap_note/screens/new_note_screen.dart';
import 'package:snap_note/screens/note_screen.dart';
import 'package:snap_note/util/constants.dart';
import 'package:snap_note/util/database.dart';
import 'package:tinycolor/tinycolor.dart';

class NotesScreen extends StatefulWidget {
  static const String tag = "/notes";

  @override
  State<StatefulWidget> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool isSearchOn = false;
  bool isSelectOn = false;
  String searchText = "";
  List<int> selectedItemsIds = new List();

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
                    Text(
                      "Notes",
                      style: TextStyle(color: Colors.white, fontSize: 40.0),
                    ),
                    isSearchOn && !isSelectOn
                        ? Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: TextField(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                    maxLines: 1,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                      hintText: "Enter text to search for...",
                                      hintStyle: TextStyle(color: kHintTextColor, fontSize: 20.0),
                                    ),
                                    textCapitalization: TextCapitalization.sentences,
                                    onChanged: (value) {
                                      setState(() {
                                        searchText = value;
                                      });
                                    },
                                  ),
                                  flex: 6,
                                ),
                                Expanded(
                                  child: SizedBox(),
                                  flex: 1,
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    isSelectOn
                        ? Row(
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
                                button: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isSelectOn = false;
                                      selectedItemsIds.clear();
                                    });
                                  },
                                  iconSize: 30.0,
                                  icon: Icon(Icons.cancel),
                                ),
                              ),
                            ],
                          )
                        : NavigationButton(
                            button: IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearchOn ^= true;
                                  if (!isSearchOn) {
                                    searchText = "";
                                  }
                                });
                              },
                              iconSize: 30.0,
                              icon: isSearchOn ? Icon(Icons.search_off) : Icon(Icons.search),
                            ),
                          ),
                  ],
                ),
              ),
              FutureBuilder<List<Note>>(
                future: isSearchOn ? DBProvider.db.getNotes(searchText) : DBProvider.db.getAllNotes(),
                builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      flex: 90,
                      child: Container(
                        padding: EdgeInsets.only(top: 15.0),
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                if (!isSelectOn) {
                                  Navigator.of(context).pushNamed(
                                    NoteScreen.tag,
                                    arguments: snapshot.data[index].id,
                                  );
                                } else {
                                  setState(() {
                                    if (selectedItemsIds.contains(snapshot.data[index].id)) {
                                      selectedItemsIds.remove(snapshot.data[index].id);
                                    } else {
                                      selectedItemsIds.add(snapshot.data[index].id);
                                    }
                                  });
                                }
                              },
                              onLongPress: () {
                                setState(() {
                                  isSelectOn = true;
                                  selectedItemsIds.add(snapshot.data[index].id);
                                });
                              },
                              child: Card(
                                color: kNoteColors[index % 7],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].title,
                                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat.yMMMd("en_US")
                                                  .format(DateTime.parse(snapshot.data[index].date)),
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: TinyColor(kNoteColors[index % 7]).darken(50).color,
                                              ),
                                            ),
                                            selectedItemsIds.contains(snapshot.data[index].id)
                                                ? Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          },
                          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(NewNoteScreen.tag);
          },
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  deleteAlert(BuildContext context) {
    Alert(
      context: context,
      title: "Are you sure you want to delete all selected notes?",
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
            Notes().deleteSelectedNotes(selectedItemsIds);
            Navigator.pop(context);
            setState(() {
              isSelectOn = false;
            });
          },
          color: Colors.red,
        ),
      ],
    ).show();
  }
}
