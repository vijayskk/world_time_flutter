// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/loading.dart';
import 'package:world_time/pages/selection.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.black, // status bar color
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/loading",
    routes: {
      "/loading": (context) => Loading(),
      "/": (context) => HomeScreen(),
      "/select": (context) => SelectionScreen(),
    },
    theme: ThemeData(primaryColor: Colors.indigo[900]),
  ));
}
