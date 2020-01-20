import 'package:cafelog/Util/numberFormat.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyCafeLog extends StatefulWidget {
  @override
  _MyCafeLog createState() => _MyCafeLog();
}

class _MyCafeLog extends State<MyCafeLog> {

  String nickName = "";
  int nowExp = 1;
  int endExp = 1000;

  appBar() {
    return AppBar(
      backgroundColor: White,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        "내 카페로그",
        style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Black),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.settings,
            color: Color.fromARGB(255, 167, 167, 167),
          ),
        )
      ],
    );
  }


  @override
  void initState() {
    super.initState();

    nickName = "CafeLog";

    print("${nowExp / endExp}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: White,
      resizeToAvoidBottomInset: true,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              whiteSpaceH(40),
              ClipOval(
                child: Container(
                  width: 100,
                  height: 100,
                  color: Color.fromARGB(255, 216, 216, 216),
                  child: Center(
                    child: Text(
                      nickName.substring(0, 1),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: White,
                          fontSize: 50),
                    ),
                  ),
                ),
              ),
              whiteSpaceH(10),
              Text(nickName, style: TextStyle(
                color: Color.fromARGB(255, 8, 0, 0),
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),),
              whiteSpaceH(10),
              Container(
                width: 43, height: 15,
                color: Color.fromARGB(255, 255, 179, 53),
                child: Center(
                  child: Text("카페로거", style: TextStyle(
                    fontSize: 8, color: White, fontWeight: FontWeight.bold
                  ),),
                ),
              ),
              whiteSpaceH(40),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("레벨 1", textAlign: TextAlign.start, style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12, color: Black,
                      ),),
                    ),
                    Text("레벨 2", style: TextStyle(
                      color: Color.fromARGB(255, 167, 167, 167),
                      fontSize: 12, fontWeight: FontWeight.w600
                    ),)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 21, right: 25),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(numberFormat.format(1), textAlign: TextAlign.start, style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 8, color: Color.fromARGB(255, 167, 167, 167),
                      ),),
                    ),
                    Text(numberFormat.format(1000), style: TextStyle(
                        color: Color.fromARGB(255, 167, 167, 167),
                        fontSize: 8, fontWeight: FontWeight.w600
                    ),)
                  ],
                ),
              ),
              whiteSpaceH(3),
              Padding(
                padding: EdgeInsets.only(left: 23, right: 25),
                child: LinearProgressIndicator(
                  backgroundColor: Color.fromARGB(255, 240, 240, 240),
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 179, 53)),
                  value: nowExp / endExp,
                ),
              ),
              whiteSpaceH(5),
              Padding(
                padding: EdgeInsets.only(left: 21, right: 25),
                child: GestureDetector(
                  onTap: () {
                    print("내 카페로그 상세");
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "1", style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 8, color: Black
                        ),
                        ),
                      ),
                      Text("더보기", style: TextStyle(
                          color: mainColor, fontSize: 12, fontWeight: FontWeight.w600
                      ),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
