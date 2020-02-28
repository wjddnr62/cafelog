import 'dart:async';

import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class Splash extends StatefulWidget{
  @override
  _Splash createState() => _Splash();
}


class _Splash extends State<Splash> {
//  var context;

  @override
  Widget build(BuildContext context) {
//    WidgetsBinding.instance.addPostFrameCallback((_) => startTime());
    Size size = MediaQuery.of(context).size;
//    this.context = context;
    return Scaffold(
      body: Container(
        color: White,
        child: Center(
          child: Image.asset("assets/logo.png", width: MediaQuery.of(context).size.width / 2,)
        ),
      ),
    );
  }

  SharedPreferences prefs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  loginCheck() async {
    prefs = await SharedPreferences.getInstance();
    print("accessToken : ${prefs.getString("userId")}");
    if (prefs.getString("userId") != null && prefs.getString("userId") != "") {
      mainBloc.updateFcmKey(
          prefs.getString(await _firebaseMessaging.getToken()),
          prefs.getString("userId"));
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/Home", (Route<dynamic> route) => false);
    } else {
      startTime();
    }
  }

  @override
  void initState() {
    super.initState();

    loginCheck();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Home');
  }

}
