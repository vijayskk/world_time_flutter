// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? timenow;
  String? zone;
  bool isNight = true;

  getTime(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? time = sp.getString('time');
    if (time != null) {
      setState(() {
        timenow = DateTime.parse(time);
        zone = sp.getString('currentzone');
      });
    } else {
      Navigator.of(context).pushReplacementNamed('/loading');
    }
    if (timenow != null) {
      if (timenow!.hour < 6 || timenow!.hour > 18) {
        setState(() {
          isNight = true;
        });
      } else {
        setState(() {
          isNight = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getTime(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: (isNight)
                  ? Image.asset(
                      "assets/night.webp",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    )
                  : Image.asset(
                      "assets/day.jpg",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    )),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: TextButton.icon(
                    label: Text(
                      "Edit location",
                      style: TextStyle(
                          color: (isNight) ? Colors.white : Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/select');
                    },
                    icon: Icon(
                      Icons.location_on,
                      color: (isNight) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_city_outlined,
                          color: (isNight) ? Colors.white : Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          (zone != null) ? zone! : "Loading...",
                          style: TextStyle(
                              color: (isNight) ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: Text(
                    (timenow != null)
                        ? "${timenow!.hour.toString().padLeft(2, '0')} : ${timenow!.minute.toString().padLeft(2, '0')}"
                        : "",
                    style: TextStyle(
                        color: (isNight) ? Colors.white : Colors.black,
                        fontSize: 70,
                        fontWeight: FontWeight.w800),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
