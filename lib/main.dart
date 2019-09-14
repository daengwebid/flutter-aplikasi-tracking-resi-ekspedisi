import 'package:flutter/material.dart';
import './silincah.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daengweb.id',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: ResiSilincah(),
    );
  }
}