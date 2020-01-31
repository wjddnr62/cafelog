import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

CafeLogSnackBarWithOk({msg, context, okMsg}) {
  Flushbar flushbar;
   flushbar = Flushbar(
    message: msg,
    backgroundColor: Black,
    margin: const EdgeInsets.all(10.0),
    borderRadius: 60.0,
    duration: Duration(seconds: 3),
    flushbarStyle: FlushbarStyle.FLOATING,
    mainButton: FlatButton(child: Text(okMsg,style: TextStyle(color: mainColor),),onPressed: (){flushbar.dismiss(true);},),
  )..show(context);

  return flushbar;
}
