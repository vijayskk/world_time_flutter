// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    getTime(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/loading.gif'),
          ],
        ),
      ),
    );
  }

  void push(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/');
  }

  void getTime(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? currentzone = sp.getString('currentzone');
    late Response res;
    // ignore: prefer_conditional_assignment
    if (currentzone == null) {
      await sp.setString('currentzone', " Asia/Kolkata");
      currentzone = " Asia/Kolkata";
    }
    res = await get(Uri.parse(
        'http://worldtimeapi.org/api/timezone/${currentzone.trim()}'));
    Response zones =
        await get(Uri.parse('http://worldtimeapi.org/api/timezone'));
    List timezones = jsonDecode(zones.body);
    Map data = jsonDecode(res.body);
    String datetime = data['datetime'];
    int offset = data['raw_offset'];
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(seconds: offset));
    await sp.setString('time', now.toIso8601String());
    await sp.setString('zones', timezones.toString());
    push(context);
  }
}
