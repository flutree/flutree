import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalOrLine extends StatelessWidget {
  /// In auth page
  /// https://stackoverflow.com/a/61304861/13617136
  const HorizontalOrLine({
    this.label,
    this.height,
  });

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
              child: Divider(
                color: Colors.black,
                height: height,
              )),
        ),
        Text(label),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: height,
              )),
        ),
      ]),
    );
  }
}
