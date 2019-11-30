import 'package:flutter/material.dart';
import 'auth.dart';
import 'globals.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignOut});

  final AuthASP auth;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        navigatorKey: auth.alice.getNavigatorKey(),
     //   debugShowCheckedModeBanner: false,
        home: new Scaffold(

      appBar: AppBar(
        title: Text('Logged In'),
      ),
      body: GetUserInfo(),
    )
    );
  }
  //In future builder, it calls the future function to wait for the result, and as soon as it produces the result it calls the builder function where we build the widget.
  Widget GetUserInfo() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return  new FlatButton(
            key: new Key('Alice'),
            child: new Text("show inspector"),
            onPressed: () {auth.ShowInspector();}
        );   //we have data
      },
      future: auth.UserInfo(),
    );
  }



}