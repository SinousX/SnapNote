import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const kBackgroundColor = Color(0xFF252525);

const kFloatingActionButtonBackgroundColor = Color(0xFF252525);

const List<Color> kNoteColors = [
  Color(0xFFFFAB91),
  Color(0xFFFFCC80),
  Color(0xFFE6EE9B),
  Color(0xFF80DEEA),
  Color(0xFFCF93D9),
  Color(0xFF80CBC4),
  Color(0xFFF48FB1),
];

const kHintTextColor = Color(0xFF929292);

const kAlertStyle = AlertStyle(
  animationType: AnimationType.grow,
  titleStyle: TextStyle(color: Colors.white),
  descStyle: TextStyle(color: Colors.white),
  backgroundColor: kBackgroundColor,
);
