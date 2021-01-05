import 'dart:convert';

Note noteFromMap(String str) => Note.fromMap(json.decode(str));

String noteToMap(Note data) => json.encode(data.toMap());

class Note {
  Note({
    this.id,
    this.title,
    this.text,
    this.date,
  });

  int id;
  String title;
  String text;
  String date;

  factory Note.fromMap(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        text: json["text"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "text": text,
        "date": date,
      };
}
