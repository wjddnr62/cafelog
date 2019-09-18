import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';

class LoginMain extends StatefulWidget {
  @override
  _LoginMain createState() => _LoginMain();
}

class _LoginMain extends State<LoginMain> {
  String mainTitle = "전국 핫한 카페를\n내 손 안에";
  String subTitle =
      "카페로그는 SNS와 포털 사이트에\n있는 카페 정보를 정확하게\n분류해주는 국내 최초 카페 전용\n플랫폼입니다.";
  String notifiText = "인스타그램 로그인 시,\n지금까지의 카페투어 기록이 자동 정리됩니다.";

  TextStyle mainTitleStyle =
      TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
  TextStyle subTitleStyle =
      TextStyle(fontSize: 12, color: Color.fromARGB(255, 122, 122, 122));
  TextStyle notifiStyle = TextStyle(fontSize: 12, color: mainColor);

  LinearGradient instaGradient =
      LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
//    tileMode: TileMode.repeated,
          stops: [
        0.1,
        0.25,
        0.5,
        0.75,
        1.0
      ], colors: [
    Color(0xFFf09433),
    Color(0xFFe6683c),
    Color(0xFFdc2743),
    Color(0xFFcc2366),
    Color(0xFFbc1888),
  ]);

  Shader startGradient = LinearGradient(colors: [
    Color.fromARGB(255, 255, 44, 85),
    Color.fromARGB(255, 252, 0, 49)
  ],).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                color: White,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                width: 15,
                                height: 15,
                                color: mainColor,
                              ),
                            ),
                            whiteSpaceH(15),
                            Text(
                              mainTitle,
                              style: mainTitleStyle,
                            ),
                            whiteSpaceH(20),
                            Text(
                              subTitle,
                              style: subTitleStyle,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset('assets/login/Rectangle1.png'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: White,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      notifiText,
                      style: notifiStyle,
                      textAlign: TextAlign.center,
                    ),
                    whiteSpaceH(20),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.of(context).pushNamed('/InstaLogin');
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0.0,
                          padding: EdgeInsets.zero,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                                gradient: instaGradient,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "인스타그램으로 시작하기",
                                style: TextStyle(fontSize: 14, color: White),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    whiteSpaceH(10),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                    ),
                    whiteSpaceH(20),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed("/Home");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: White,
                        child: Center(
                          child: Text(
                            "바로시작",
                            style: TextStyle(
                                foreground: Paint()..shader = startGradient, fontSize: 14),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
