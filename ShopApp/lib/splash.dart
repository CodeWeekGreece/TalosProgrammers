import 'package:book_in_shop/home.dart';
import 'package:book_in_shop/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class SplashScreen extends StatefulWidget {
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogged = false;
  List data = [];
  Future<bool> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final islogged = prefs.getBool("loggedIn");
    if (islogged == null) {
      return false;
    }
    return islogged;
  }

  Future<void> _boolLog() async {
    final prefs = await SharedPreferences.getInstance();
    bool checkLog = await _checkIfLoggedIn();
    setState(() {
      isLogged = checkLog;
    });
  }

  Future<List> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getStringList("userData");
    if (userData == null) {
      return [];
    }
    return userData;
  }

  Future<void> _userData() async {
    final prefs = await SharedPreferences.getInstance();
    List userData = await _getUser();
    setState(() {
      data = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    _boolLog();
    _userData();
    Timer(Duration(seconds: 1), () => closeSplash());
  }


  void closeSplash() async {
    if (isLogged) {
      final user = ParseUser(data[0], data[1], null);

      void response = await user.login();
      Timer(
          Duration(seconds: 2),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage())));
    } else {
      Timer(
          Duration(seconds: 2),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Book In",
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(
                height: 30.0,
              ),
              SpinKitSquareCircle(color: Colors.black87)
            ],
          ),
        ),
      ),
    );
  }
}
