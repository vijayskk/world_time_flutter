// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List? timezones;

  getZones() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? zonestr = sp.getString('zones');
    if (zonestr != null) {
      setState(() {
        timezones = zonestr.substring(1, zonestr.length - 1).split(',');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Center(
          child: Text(
            "Pick a location",
          ),
        ),
      ),
      body: Container(
        child: Stack(children: [
          (timezones != null)
              ? ListView(
                  children:
                      timezones!.map((e) => ZoneListItem(name: e)).toList())
              : Center(child: CupertinoActivityIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: FlatButton(
                color: Colors.indigo[900],
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class ZoneListItem extends StatelessWidget {
  final String name;
  const ZoneListItem({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Icon(Icons.location_on),
        title: Text(name),
        onTap: () {
          setZone(context, name);
        },
      ),
    );
  }

  setZone(BuildContext context, String zone) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool status = await sp.setString('currentzone', zone);
    if (status) {
      Navigator.of(context).pushReplacementNamed('/loading');
    }
  }
}
