import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snap_note/screens/notes_screen.dart';
import 'package:snap_note/util/constants.dart';
import 'package:snap_note/util/route_generator.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(Platform.localeName.split('_')[0]),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('pl'),
      ],
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: kBackgroundColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kFloatingActionButtonBackgroundColor,
        ),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: NotesScreen(),
    );
  }
}
