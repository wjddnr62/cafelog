import 'dart:math';

import 'package:cafelog/Model/cafeLocationSearchData.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocationSearch extends StatefulWidget {
  @override
  _LocationSearch createState() => _LocationSearch();
}

class _LocationSearch extends State<LocationSearch> {
  String cafeLoadTitle = "";
  List<CafeLocationSearchData> _cafeList = List();
  final numberFormat = NumberFormat("#,###");

  @override
  void initState() {
    super.initState();

    cafeLoadTitle = "서울 카페거리";

    _cafeList.add(CafeLocationSearchData(
        cafeCount: 12,
        img: "assets/test/test1.png",
        locationName: "경리단길(이태원)",
        personCount: 155));
    _cafeList.add(CafeLocationSearchData(
        cafeCount: 151,
        img: "assets/test/test2.png",
        locationName: "성수동 카페거리",
        personCount: 10821));
    _cafeList.add(CafeLocationSearchData(
        cafeCount: 583,
        img: "assets/test/test3.png",
        locationName: "연트럴파크(연희동)",
        personCount: 103821));
    _cafeList.add(CafeLocationSearchData(
        cafeCount: 777,
        img: "assets/test/test4.png",
        locationName: "아이오에오",
        personCount: 2451));
    _cafeList.add(CafeLocationSearchData(
        cafeCount: 888,
        img: "assets/test/test5.png",
        locationName: "가나다라마",
        personCount: 23));
  }

  cafeListGrid() =>  GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 5.0,
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height /
                    0.85),
            itemCount: _cafeList.length,
            itemBuilder: (context, idx) {
              return Padding(
                padding: idx % 2 == 0 ? EdgeInsets.only(left: 15) : EdgeInsets.only(right: 15),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 280,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 80),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: White,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                          Color.fromARGB(255, 219, 219, 219),
                                          blurRadius: 7),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 160,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    _cafeList[idx].img,
                                    fit: BoxFit.fill,
                                    width: 170,
                                    height: 160,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: White,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).padding.top + 40,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          right: 0,
                          top: 20,
                          child: GestureDetector(
                            onTap: () {
                              print("전체카페로 지정");
                            },
                            child: Text(
                              "전체카페로 지정",
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: 30,
                          child: Text(
                            cafeLoadTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Black),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  )),
              Expanded(
                child: cafeListGrid(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          color: mainColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0.4,
      ),
    );
  }
}
