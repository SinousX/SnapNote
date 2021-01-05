import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class NavigationButton extends StatelessWidget {
  final Widget button;
  final bool isDisabled;

  NavigationButton({
    @required this.button,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: this.isDisabled ? TinyColor(Color(0xFF3B3B3B)).darken(50).color : Color(0xFF3B3B3B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: this.button,
    );
  }
}
