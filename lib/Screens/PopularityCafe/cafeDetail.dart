import 'dart:math' show cos, sqrt, asin;

import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../colors.dart';

class CafeDetail extends StatefulWidget {
  @override
  _CafeDetail createState() => _CafeDetail();
}

class _CafeDetail extends State<CafeDetail> {
  bool mainImageCheck = false;
  bool personCheck = false;
  bool menuCheck = false;
  bool userImageCheck = false;

  double topHeight = 0.0;

  bool gpsOn = false;

  String title = "하이데어";
  String distance = "1.7km";
  bool open = true;

  String cafeDes = "커피보다 스콘이 맛있는 카페";
  String cafeAddress = "서울특별시 중구 충무로9길 0223 1층 ACAFE";

  final numberFormat = NumberFormat("#,###");
  int personNumAll = 52100;
  int personWeek = 500;

  List<String> serviceTag = List();

  cal() {
    // 거리 계산 메소드 이용
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    double totalDistance =
        calculateDistance(37.457176, 126.702209, 37.490364, 126.723441);
    print(totalDistance.toStringAsFixed(1));
    // 결과값 ex) 4.1 (단위 : km);
  }

  gpsCheck() async {
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (isLocationEnabled)
      setState(() {
        gpsOn = true;
      });
    else
      setState(() {
        gpsOn = false;
      });
  }

  @override
  void initState() {
    super.initState();

    gpsCheck();

    serviceTag..add("주차가능")
    ..add("반려견출입가능")
    ..add("노키즈존")
    ..add("공기청정기")
    ..add("아이오에오");
  }

  favoriteFab() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.star_border,
          color: mainColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0.6,
        heroTag: "favorite",
      ),
    );
  }

  backFab() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          color: mainColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0.6,
        heroTag: "back",
      ),
    );
  }

  mainImage() => mainImageCheck
      ? Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20 + topHeight),
          // CachedNetworkImage 로 변경할 것
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/test/test1.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
        )
      : Container();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    topHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: White,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
//            height: MediaQuery.of(context).size.,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: !mainImageCheck ? 20 + topHeight : 165 + topHeight,
                            bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: White,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 167, 167, 167),
                                    blurRadius: 8),
                              ]),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding:
                                  EdgeInsets.only(top: mainImageCheck ? 205 : 20),
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 120,
//                                    padding: EdgeInsets.only(left: 80, right: 80),
                                          child: Text(
                                            title,
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Black),
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        left: 50,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 120),
                                            child: gpsOn
                                                ? Text(
                                              distance,
                                              style: TextStyle(
                                                  color: Black, fontSize: 12),
                                              textAlign: TextAlign.center,
                                            )
                                                : Text(""),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: open
                                                ? Padding(
                                              padding: EdgeInsets.only(right: 15),
                                              child: Text(
                                                "영업중",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: mainColor),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                                : Text(""),
                                          ))
                                    ],
                                  )),
                              whiteSpaceH(30),
                              Text(
                                cafeDes,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 122, 122, 122),
                                    fontSize: 12),
                              ),
                              whiteSpaceH(10),
                              Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 200,
                                      child: Text(
                                        cafeAddress,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color:
                                            Color.fromARGB(255, 104, 104, 104)),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 25),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            "지도보기",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: mainColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              whiteSpaceH(55),
                              Center(
                                child: Text("다녀온 사람", style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 167, 167, 167)
                                ),),
                              ),
                              (personNumAll != 0 && personNumAll != null) ? Column(
                                children: <Widget>[
                                  whiteSpaceH(5),
                                  Center(
                                    child: Text("${numberFormat.format(personNumAll)} 명", style: TextStyle(
                                        color: Black, fontSize: 12, fontWeight: FontWeight.w600
                                    ),),
                                  ),
                                  whiteSpaceH(7),
                                  Center(
                                    child: Text("최근 1주일 ${numberFormat.format(personWeek)} 명", style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 10, color: mainColor
                                    ),),
                                  )
                                ],
                              ) : Column(
                                children: <Widget>[
                                  whiteSpaceH(10),
                                  Center(
                                    child: Text("아직 다녀온 사람이 없습니다.\n첫 기록을 남겨보세요!", style: TextStyle(
                                      color: Color.fromARGB(255, 122, 122, 122),
                                      fontSize: 12
                                    ),),
                                  )
                                ],
                              ),
                              whiteSpaceH(40),
                              Center(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text("전화걸기", style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600, color: mainColor
                                  ),),
                                ),
                              ),
                              whiteSpaceH(40),
                              Padding(
                                padding: EdgeInsets.only(left: 40, right: 40),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  child: GridView.count(
                                    crossAxisCount: 4,
                                    shrinkWrap: true,
                                    childAspectRatio: 2,
                                    children: List.generate(serviceTag.length, (idx) {
                                      return Text("#${serviceTag[idx]}", style: TextStyle(
                                          color: Color.fromARGB(255, 122, 122, 122),
                                          fontSize: 12
                                      ), textAlign: TextAlign.center,);
                                    }),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      mainImage(),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20, bottom: 20),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: favoriteFab(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20, bottom: 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: backFab(),
                        ),
                      )
                    ],
                  ),
                )

              ],
            )),
      ),
    );
  }
}
