import 'dart:ui';

import 'package:flutter/material.dart';

class TimerButton extends StatelessWidget {
  const TimerButton({this.icon, this.function, this.string});

  final Icon icon;
  final Function function;
  final String string;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return ButtonTheme(
      minWidth: size.width / 4,
      height: size.height / 4,
      child: RaisedButton.icon(
        icon: icon,
        onPressed: function,
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        label: Text(string),
      ),
    );
  }
}
