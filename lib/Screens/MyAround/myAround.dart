import 'dart:math';

import 'package:cafelog/Model/myAroundData.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';
import 'package:cafelog/colors.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class MyAround extends StatefulWidget {
  @override
  _MyAround createState() => _MyAround();
}

class _MyAround extends State<MyAround> {
  BoxDecoration selectFilterDeco =
      BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(16));
  TextStyle selectFilterStyle = TextStyle(color: White, fontSize: 12);
  TextStyle nonSelectFilterStyle =
      TextStyle(color: Color.fromARGB(255, 122, 122, 122), fontSize: 12);

  BoxDecoration tagDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color.fromARGB(255, 247, 247, 247));

  BoxDecoration tagClickDecoration =
      BoxDecoration(borderRadius: BorderRadius.circular(5), color: mainColor);

  List<String> tagListItem = [
    "마카롱",
    "흑당라떼",
    "케이크",
    "베이커리",
    "레스토랑",
    "테스트",
    "테스트2",
    "테스트3",
    "테스트4",
    "테스트5",
    "테스트6",
    "테스트7"
  ];

  List<bool> tagClick = List();
  int clickNum;
  List<String> tagSelectList = List();

  bool visitCafe = false;
  bool open = false;
  bool gpsOn = false;

  List<MyAroundData> aroundRecoData = List();
  List<MyAroundData> aroundData = List();

  bool loading = true;

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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  distance(lat1, lon1, lat2, lon2) {
    double totalDistance = calculateDistance(lat1, lon1, lat2, lon2);

    return totalDistance.toStringAsFixed(1).toString();
  }

  var currentLocation;
  var location = new Location();

  List<String> km = List();

  getLocation() async {
    currentLocation = await location.getLocation();
  }

  Future<String> getDistance(cafeAddress) async {
    var address = await Geocoder.local.findAddressesFromQuery(cafeAddress);
    var first = address.first;

    final coordinates = first.coordinates;

    currentLocation = await location.getLocation();

    print("current : ${currentLocation.latitude}, ${currentLocation.longitude}");

    String km =
        "${distance(currentLocation.latitude, currentLocation.longitude, coordinates.latitude, coordinates.longitude)}km";

    return km;
  }

  tagList() => ListView.builder(
        itemCount: tagListItem.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (!tagClick[position]) {
                    tagClick[position] = true;
                    tagSelectList.add(tagListItem[position]);
                  } else {
                    tagClick[position] = false;
                    tagSelectList.removeAt(position);
                  }
//                  if (clickNum == position) {
//                    clickNum = null;
//                    // 선택해제
//                  } else {
//                    clickNum = position;
//                    // 선택
//                  }
                });
                print("태그 클릭 : " + tagListItem[position]);
              },
              child: Container(
                width: 60,
                height: 30,
                decoration:
                    tagClick[position] ? tagClickDecoration : tagDecoration,
                child: Center(
                  child: Text(
                    "#${tagListItem[position]}",
                    style: tagClick[position]
                        ? TextStyle(fontSize: 12, color: White)
                        : TextStyle(fontSize: 12, color: Black),
                  ),
                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      );

  @override
  void initState() {
    super.initState();

    gpsCheck();

    for (int i = 0; i < tagListItem.length; i++) {
      tagClick.add(false);
    }

    aroundRecoData
      ..add(MyAroundData(
          cafeImg: "assets/test/test1.png",
          cafeName: "투더문바",
          cafeAddress: "서울특별시 중구 청계천로 14 1F",
          openCheck: 0,
          type: 0,
          sale: 100,
          visitor: 125))
      ..add(MyAroundData(
          cafeImg: "assets/test/test2.png",
          cafeName: "쎄투",
          cafeAddress: "서울특별시 중구 청계천로 34",
          openCheck: 1,
          type: 0,
          sale: 300,
          visitor: 125))
      ..add(MyAroundData(
          cafeImg: "assets/test/test3.png",
          cafeName: "37.5도",
          cafeAddress: "서울특별시 중구 청계천로 512 신한투자금융 1층",
          openCheck: 1,
          type: 0,
          sale: 200,
          visitor: 125));
    aroundData
      ..add(MyAroundData(
          cafeImg: "assets/test/test4.png",
          cafeName: "하이데어",
          cafeAddress: "서울특별시 중구 청계천로 14 1F",
          openCheck: 1,
          type: 1,
          sale: 0,
          visitor: 125))
      ..add(MyAroundData(
          cafeImg: "assets/test/test5.png",
          cafeName: "에이카페",
          cafeAddress: "서울특별시 중구 청계천로 14 1F",
          openCheck: 0,
          type: 1,
          sale: 0,
          visitor: 125))
      ..add(MyAroundData(
          cafeImg: "",
          cafeName: "카페로그",
          cafeAddress: "서울특별시 중구 청계천로 14 1F",
          openCheck: 1,
          type: 1,
          sale: 0,
          visitor: 125));

    km.clear();

    for (int i = 0; i < aroundRecoData.length; i++) {
      getDistance(aroundRecoData[i].cafeAddress).then((value) {
//        print("value : ${value}");
        setState(() {
          km.add(value);
        });
      });
    }

    for (int i = 0; i < aroundData.length; i++) {
      getDistance(aroundData[i].cafeAddress).then((value) {
//        print("value : ${value}");
        setState(() {
          km.add(value);
        });
      });
    }

    print("kmLength : ${km.length}");

    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, top: 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (open) {
                            open = false;
                          } else {
                            open = true;
                          }
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 30,
                        decoration: BoxDecoration(
                          color: open == false
                              ? White
                              : Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "영업중",
                            style: open == false
                                ? TextStyle(
                                    color: Color.fromARGB(255, 122, 122, 122),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)
                                : TextStyle(
                                    color: Black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, right: 15),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (visitCafe) {
                            visitCafe = false;
                          } else {
                            visitCafe = true;
                          }
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: visitCafe == false
                              ? White
                              : Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "다녀온카페 제외",
                            style: visitCafe == false
                                ? TextStyle(
                                    color: Color.fromARGB(255, 122, 122, 122),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)
                                : TextStyle(
                                    color: Black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, top: 10, right: 10),
            child: Container(
              height: 30,
              child: tagList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, top: 15, right: 15),
            child: Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                    text: '* 제휴 할인 : ',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 167, 167, 167)),
                    children: <TextSpan>[
                      TextSpan(
                        text: "전용 텀블러",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: mainColor),
                      ),
                      TextSpan(
                        text: "로 테이크아웃 시 적용",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 167, 167, 167)),
                      )
                    ]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "추천카페",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 63, 61, 61),
                  fontSize: 24),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: ListView.builder(
              itemBuilder: (context, idx) {
//                print("idx : ${aroundRecoData[idx].cafeName}");

                print("kmLength2 : ${km.length}, ${idx}");
                if (km.length > idx) {
                  if (km.length != 0 && km[idx].isNotEmpty) {
                    print("kmIDX :  ${km[idx]}");
                  }
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Stack(
                    children: <Widget>[
                      (aroundRecoData[idx].cafeImg != null &&
                              aroundRecoData[idx].cafeImg != "")
                          ? Positioned(
                              child: Padding(
                                padding: EdgeInsets.only(left: 75),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    padding:
                                        EdgeInsets.only(left: 60, right: 10),
                                    decoration: BoxDecoration(
                                      color: White,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 167, 167, 167),
                                            blurRadius: 8)
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          whiteSpaceH(10),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  aroundRecoData[idx].cafeName,
                                                  style: TextStyle(
                                                    color: Black,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: gpsOn
                                                    ? km.length > idx
                                                        ? (km.length != 0 &&
                                                                km[idx]
                                                                    .isNotEmpty)
                                                            ? Text("${km[idx]}")
                                                            : Container()
                                                        : Container()
                                                    : Container(),
                                              )
                                            ],
                                          ),
                                          whiteSpaceH(20),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  "${aroundRecoData[idx].sale}원 할인",
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Text(
                                                aroundRecoData[idx].openCheck ==
                                                        1
                                                    ? "영업중"
                                                    : "영업종료",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: aroundRecoData[idx]
                                                                .openCheck ==
                                                            1
                                                        ? mainColor
                                                        : Color.fromARGB(
                                                            255, 53, 159, 255)),
                                              )
                                            ],
                                          ),
                                          whiteSpaceH(20),
                                          RichText(
                                            text: TextSpan(
                                                text: "다녀온 사람 ",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 167, 167, 167),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          "${aroundRecoData[idx].visitor}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                          color: Black))
                                                ]),
                                          ),
                                          whiteSpaceH(aroundRecoData[idx].cafeAddress.length > 20 ? 5 : 20),
                                          Expanded(
                                            child: Text(
                                              aroundRecoData[idx].cafeAddress,
                                              style: TextStyle(
                                                color: Black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            )
                          : Positioned(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: White,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 167, 167, 167),
                                          blurRadius: 8)
                                    ],
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        whiteSpaceH(10),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                aroundRecoData[idx].cafeName,
                                                style: TextStyle(
                                                  color: Black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: gpsOn
                                                  ? km.length > idx
                                                      ? (km.length != 0 &&
                                                              km[idx]
                                                                  .isNotEmpty)
                                                          ? Text("${km[idx]}")
                                                          : Container()
                                                      : Container()
                                                  : Container(),
                                            ),
                                          ],
                                        ),
                                        whiteSpaceH(20),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "${aroundRecoData[idx].sale}원 할인",
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                              aroundRecoData[idx].openCheck == 1
                                                  ? "영업중"
                                                  : "영업종료",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: aroundRecoData[idx]
                                                              .openCheck ==
                                                          1
                                                      ? mainColor
                                                      : Color.fromARGB(
                                                          255, 53, 159, 255)),
                                            )
                                          ],
                                        ),
                                        whiteSpaceH(20),
                                        RichText(
                                          text: TextSpan(
                                              text: "다녀온 사람 ",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 167, 167, 167),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "${aroundRecoData[idx].visitor}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: Black))
                                              ]),
                                        ),
                                        whiteSpaceH(aroundRecoData[idx].cafeAddress.length > 20 ? 5 : 20),
                                        Expanded(
                                          child: Text(
                                            aroundRecoData[idx].cafeAddress,
                                            style: TextStyle(
                                              color: Black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                      (aroundRecoData[idx].cafeImg != null &&
                              aroundRecoData[idx].cafeImg != "")
                          ? Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.asset(
                                  aroundRecoData[idx].cafeImg,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: aroundRecoData.length,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Color.fromARGB(255, 151, 151, 151),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, top: 20),
            child: Text(
              "일반카페",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 63, 61, 61),
                  fontSize: 24),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 150),
            child: ListView.builder(
              itemBuilder: (context, idx) {
//                print("idx : ${aroundData[idx].cafeName}");
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Stack(
                    children: <Widget>[
                      (aroundData[idx].cafeImg != null &&
                              aroundData[idx].cafeImg != "")
                          ? Positioned(
                              child: Padding(
                                padding: EdgeInsets.only(left: 75),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    padding:
                                        EdgeInsets.only(left: 60, right: 10),
                                    decoration: BoxDecoration(
                                      color: White,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 167, 167, 167),
                                            blurRadius: 8)
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          whiteSpaceH(10),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  aroundData[idx].cafeName,
                                                  style: TextStyle(
                                                    color: Black,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: gpsOn
                                                    ? km.length >
                                                            aroundData.length
                                                        ? km.length > idx
                                                            ? (km.length != 0 &&
                                                                    km[idx +
                                                                            aroundRecoData
                                                                                .length -
                                                                            1]
                                                                        .isNotEmpty)
                                                                ? Text(
                                                                    "${km[idx + aroundRecoData.length - 1]}")
                                                                : Container()
                                                            : Container()
                                                        : Container()
                                                    : Container(),
                                              ),
                                            ],
                                          ),
                                          whiteSpaceH(20),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                ),
                                              ),
                                              Text(
                                                aroundData[idx].openCheck == 1
                                                    ? "영업중"
                                                    : "영업종료",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: aroundData[idx]
                                                                .openCheck ==
                                                            1
                                                        ? mainColor
                                                        : Color.fromARGB(
                                                            255, 53, 159, 255)),
                                              )
                                            ],
                                          ),
                                          whiteSpaceH(30),
                                          RichText(
                                            text: TextSpan(
                                                text: "다녀온 사람 ",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 167, 167, 167),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          "${aroundRecoData[idx].visitor}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                          color: Black))
                                                ]),
                                          ),
                                          whiteSpaceH(5),
                                          Expanded(
                                            child: Text(
                                              aroundData[idx].cafeAddress,
                                              style: TextStyle(
                                                color: Black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            )
                          : Positioned(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: White,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 167, 167, 167),
                                          blurRadius: 8)
                                    ],
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        whiteSpaceH(10),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                aroundData[idx].cafeName,
                                                style: TextStyle(
                                                  color: Black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: gpsOn
                                                  ? km.length >
                                                          aroundData.length
                                                      ? km.length + aroundData.length > idx + aroundData.length
                                                          ? ((km.length + aroundData.length) != (0 + aroundData.length) &&
                                                                  km[idx +
                                                                          aroundRecoData
                                                                              .length -
                                                                          2]
                                                                      .isNotEmpty)
                                                              ? Text(
                                                                  "${km[idx + aroundRecoData.length - 2]}")
                                                              : Container()
                                                          : Container()
                                                      : Container()
                                                  : Container(),
                                            )
                                          ],
                                        ),
                                        whiteSpaceH(20),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                            Text(
                                              aroundData[idx].openCheck == 1
                                                  ? "영업중"
                                                  : "영업종료",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: aroundData[idx]
                                                              .openCheck ==
                                                          1
                                                      ? mainColor
                                                      : Color.fromARGB(
                                                          255, 53, 159, 255)),
                                            )
                                          ],
                                        ),
                                        whiteSpaceH(30),
                                        RichText(
                                          text: TextSpan(
                                              text: "다녀온 사람 ",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 167, 167, 167),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "${aroundRecoData[idx].visitor}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: Black))
                                              ]),
                                        ),
                                        whiteSpaceH(5),
                                        Expanded(
                                          child: Text(
                                            aroundData[idx].cafeAddress,
                                            style: TextStyle(
                                              color: Black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                      (aroundData[idx].cafeImg != null &&
                              aroundData[idx].cafeImg != "")
                          ? Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.asset(
                                  aroundData[idx].cafeImg,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: aroundData.length,
            ),
          ),
        ],
      ),
    );
  }
}
