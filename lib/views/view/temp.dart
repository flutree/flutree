import 'package:flutter/material.dart';

class Temp extends StatelessWidget {
  Temp({this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(name ?? 'NO NAME'),
    );
  }
}
