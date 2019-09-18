import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  bool filterButton = false;

  BoxDecoration selectFilterDeco = BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(16));

  homeAppBar() =>
      AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: White,
        title: GestureDetector(
          onTap: () {
            print("카페 지역 선택");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("전체카페", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Black),),
              Icon(Icons.arrow_drop_down, color: mainColor, size: 18,)
            ],
          ),
        ), // bloc 에 카페명 저장하여 관리
        leading: IconButton(
          onPressed: () {
            print("검색");
          },
          icon: Icon(Icons.search, color: Color.fromARGB(255, 122, 122, 122), size: 30,),
        ),
        actions: <Widget>[
          whiteSpaceW(MediaQuery.of(context).size.width / 5)
        ],
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: homeAppBar(),
      backgroundColor: White,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[

              ],
            )
          ],
        ),
      ),
    );
  }
}
