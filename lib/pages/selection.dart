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
  List<String>? timezones;

  bool showSearchbox = false;

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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showSearchbox = !showSearchbox;
              });
            },
            icon: Icon(Icons.search),
          )
        ],
        title: Center(
          child: Text(
            "Pick a location",
          ),
        ),
      ),
      body: Container(
        child: Stack(children: [
          (timezones != null)
              ? AnimatedPadding(
                  duration: Duration(milliseconds: 200),
                  padding: showSearchbox
                      ? EdgeInsets.only(top: 80.0)
                      : EdgeInsets.only(top: 0.0),
                  child: ListView(
                    children:
                        timezones!.map((e) => ZoneListItem(name: e)).toList(),
                  ),
                )
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
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: AnimatedContainer(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (text) {
                      if (text == "") {
                        getZones();
                      } else {
                        searchIn(timezones!, text);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Search...", border: InputBorder.none),
                  ),
                ),
              ),
              duration: Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              width: double.infinity,
              height: showSearchbox ? 60 : 0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[100],
                boxShadow: [
                  showSearchbox
                      ? BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 3,
                          color: Colors.grey,
                        )
                      : BoxShadow(
                          blurRadius: 0,
                          spreadRadius: 0,
                          color: Colors.grey,
                        )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void searchIn(List<String> data, String a) {
    List<String> result = [];
    for (var i = 0; i < data.length; i++) {
      String str = data[i];
      List<String> keywords = str.split("/");
      if (keywords[0].toLowerCase().contains('$a')) {
        result.add(data[i]);
      } else if (keywords.length == 2) {
        if (keywords[1].toLowerCase().contains('$a')) {
          result.add(data[i]);
        }
      }
    }
    setState(() {
      timezones = result;
    });
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
