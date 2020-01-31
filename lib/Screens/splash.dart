import 'dart:async';

import 'package:flutter/material.dart';

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


  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/LoginMain');
  }

}
