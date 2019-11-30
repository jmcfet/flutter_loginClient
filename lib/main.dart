import 'package:flutter/material.dart';
import 'root_page.dart';
import 'auth.dart';
import 'package:alice/alice.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login',

      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new RootPage(auth: new AuthASP(new Alice(showNotification: true))),
    );
  }
}