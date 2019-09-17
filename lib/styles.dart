/*
 각종 style 관련 모음
 fontStyle, Decoration 등등
*/
import 'package:flutter/material.dart';
import 'colors.dart';


//fontSize
final defaultFontSize = 16.0;
final topRightFontSize = 14.0;
final appBarTitle = 16.0;
final middleFontSize = 24.0;
final largeFontSize = 28.0;
final smallFontSize = 12.0;


//TextStyle
final topRightText = TextStyle(fontSize: topRightFontSize, fontWeight: FontWeight.bold);
final loginDescription = TextStyle(fontSize: largeFontSize, color: Black,fontWeight: FontWeight.bold);
final defaultTextFormStyle = TextStyle(fontSize: middleFontSize, color: Black, fontWeight: FontWeight.bold);
final defaultWhiteTextFormStyle = TextStyle(fontSize: smallFontSize, color: White, fontWeight: FontWeight.bold);
final defaultTextHintStyle = TextStyle(fontSize: middleFontSize, color: Color(0xFFDCDCDC), fontWeight: FontWeight.bold);
final appBarText = TextStyle(fontSize: appBarTitle, color: Black, fontWeight: FontWeight.bold);
final upPanelText = TextStyle(fontSize: defaultFontSize, color: Black, fontWeight: FontWeight.bold);
final appBarActionText = TextStyle(fontSize: topRightFontSize, color: mainColor, fontWeight: FontWeight.bold);
final loginSubDescription = TextStyle(fontSize: smallFontSize, color: Black);
final loginTextStyle = TextStyle(fontSize: smallFontSize, color: mainColor,fontWeight: FontWeight.bold);
final infoAgree = TextStyle(fontSize: smallFontSize, color: Color(0xFFBBBBBB), fontWeight: FontWeight.bold);
final colorButtonText = TextStyle(fontSize: smallFontSize, color: White);

//BoxDecoration
final loginPageGoDecoration = BoxDecoration(color: White,borderRadius: BorderRadius.circular(30),border: Border.all(color: mainColor,width: 1.0));
