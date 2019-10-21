import 'dart:math' show cos, sqrt, asin;

import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Model/popularMenu.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/Widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../colors.dart';
import 'cafeLocation.dart';

class CafeDetail extends StatefulWidget {
  @override
  _CafeDetail createState() => _CafeDetail();
}

class _CafeDetail extends State<CafeDetail> {
  bool mainImageCheck = true;

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

  bool menuExist = true;

  List<PopularMenu> popularMenuList = List();

  bool cafeUserImage = true;

  int allRecord = 25366;

  List<InstaPostData> instaPostLeftData = [];
  List<InstaPostData> instaPostRightData = [];

  Map<PermissionGroup, PermissionStatus> permissions;

  Future<bool> permissionCheck() async {
    permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    print("check: " + permission.toString());
    bool pass = false;

    if (permission == PermissionStatus.granted) {
      pass = true;
    }

    return pass;
  }

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

    serviceTag..add("주차가능")..add("반려견출입가능")..add("노키즈존")..add("공기청정기");

    popularMenuList
      ..add(PopularMenu(menuName: "아메리카노", eatPerson: 675))
      ..add(PopularMenu(menuName: "브런치세트", eatPerson: 1021))
      ..add(PopularMenu(menuName: "비포선라이즈파스타", eatPerson: 786))
      ..add(PopularMenu(menuName: "베이컨파스타", eatPerson: 111))
      ..add(PopularMenu(menuName: "아메리칸브렉퍼스트", eatPerson: 213));

    for (int i = 0; i < 10; i++) {
      List<String> image = List();
      if (i >= 0 && i < 5) {
        if (i == 2) {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          image.add("assets/test/test${i + 2}.png");
          instaPostLeftData.add(InstaPostData(image, "@test${i}"));
        } else {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          instaPostLeftData.add(InstaPostData(image, "@test${i}"));
        }
      } else {
        if (i == 7) {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          image.add("assets/test/test${i + 2}.png");
          instaPostRightData.add(InstaPostData(image, "@test${i}"));
        } else {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          instaPostRightData.add(InstaPostData(image, "@test${i}"));
        }
      }
    }
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

  instaCafePost() => Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: instaPostLeftData.length,
                  itemBuilder: (context, position) {
                    if (instaPostLeftData.length != position) {
                      return GestureDetector(
                        onTap: () {
                          print("left");
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset(
                                  instaPostLeftData[position].img[0],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              child: Text(
                                instaPostLeftData[position].instaName,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: White,
                                    shadows: [
                                      Shadow(color: Black, blurRadius: 5)
                                    ]),
                              ),
                              bottom: 15,
                              left: 5,
                            ),
                            instaPostLeftData[position].img.length == 2
                                ? Positioned(
                                    child: Icon(
                                      Icons.photo_library,
                                      color: White,
                                      size: 14,
                                    ),
                                    right: 5,
                                    bottom: 15,
                                  )
                                : Container()
                          ],
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              whiteSpaceW(15),
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: instaPostRightData.length,
                  itemBuilder: (context, position) {
                    if (instaPostLeftData.length != position) {
                      return GestureDetector(
                        onTap: () {
                          print("right");
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset(
                                  instaPostRightData[position].img[0],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              child: Text(
                                instaPostRightData[position].instaName,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: White,
                                    shadows: [
                                      Shadow(color: Black, blurRadius: 5)
                                    ]),
                              ),
                              bottom: 15,
                              left: 5,
                            ),
                            instaPostRightData[position].img.length == 2
                                ? Positioned(
                                    child: Icon(
                                      Icons.photo_library,
                                      color: White,
                                      size: 14,
                                    ),
                                    right: 5,
                                    bottom: 15,
                                  )
                                : Container()
                          ],
                        ),
                      );
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
      );

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
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
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
                                top: !mainImageCheck
                                    ? 20 + topHeight
                                    : 165 + topHeight,
                                bottom: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: White,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 167, 167, 167),
                                        blurRadius: 8),
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: mainImageCheck ? 205 : 20),
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
                                                padding:
                                                    EdgeInsets.only(left: 120),
                                                child: gpsOn
                                                    ? Text(
                                                        distance,
                                                        style: TextStyle(
                                                            color: Black,
                                                            fontSize: 12),
                                                        textAlign:
                                                            TextAlign.center,
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
                                                    padding: EdgeInsets.only(
                                                        right: 15),
                                                    child: Text(
                                                      "영업중",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: mainColor),
                                                      textAlign:
                                                          TextAlign.center,
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
                                        color:
                                            Color.fromARGB(255, 122, 122, 122),
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
                                                color: Color.fromARGB(
                                                    255, 104, 104, 104)),
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
                                              onTap: () {
                                                permissionCheck().then((pass) {
                                                  if (pass == true) {
                                                    //37.468443, 126.887603
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          CafeLocation(
                                                        latLng: LatLng(
                                                            37.468443,
                                                            126.887603),
                                                        cafeAddress:
                                                            cafeAddress,
                                                      ),
                                                    ));
                                                  } else {
                                                    CafeLogSnackBarWithOk(
                                                        context: context,
                                                        msg: "위치 권한을 동의해주세요.",
                                                        okMsg: "확인");
                                                  }
                                                });
                                              },
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
                                    child: Text(
                                      "다녀온 사람",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 167, 167, 167)),
                                    ),
                                  ),
                                  (personNumAll != 0 && personNumAll != null)
                                      ? Column(
                                          children: <Widget>[
                                            whiteSpaceH(5),
                                            Center(
                                              child: Text(
                                                "${numberFormat.format(personNumAll)} 명",
                                                style: TextStyle(
                                                    color: Black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            whiteSpaceH(7),
                                            Center(
                                              child: Text(
                                                "최근 1주일 ${numberFormat.format(personWeek)} 명",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: mainColor),
                                              ),
                                            )
                                          ],
                                        )
                                      : Column(
                                          children: <Widget>[
                                            whiteSpaceH(10),
                                            Center(
                                              child: Text(
                                                "아직 다녀온 사람이 없습니다.\n첫 기록을 남겨보세요!",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 122, 122, 122),
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                  whiteSpaceH(40),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        print('전화걸기');
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 248, 248, 248),
                                              elevation: 0.0,
                                              contentPadding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                              content: Container(
                                                width: 270,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    whiteSpaceH(20),
                                                    Center(
                                                      child: Text(
                                                        "02-1234-5678",
                                                        style: TextStyle(
                                                            color: Black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                    whiteSpaceH(5),
                                                    Center(
                                                      child: Text(
                                                        "위의 번호로 전화하시겠습니까?",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Black),
                                                      ),
                                                    ),
//                                                      whiteSpaceH(35),
//                                                      Container(
//                                                        width: MediaQuery.of(context).size.width,
//                                                        height: 1,
//                                                        color: Color.fromRGBO(0, 0, 0, 0.15),
//                                                      ),
//                                                      Row(
//                                                        children: <Widget>[
//                                                          Expanded(
//                                                            child: RaisedButton(
//                                                              onPressed: (){
//                                                                launch("tel:0212345678");
//                                                              },
//                                                              elevation: 0.0,
//                                                              color: Color.fromARGB(255, 248, 248, 248),
//                                                              child: Center(
//                                                                child: Text("전화걸기", style: TextStyle(
//                                                                  fontSize: 17, fontWeight: FontWeight.bold,
//                                                                  color: Color.fromARGB(255, 0, 122, 255)
//                                                                ),),
//                                                              ),
//                                                            ),
//                                                          ),
//                                                          Container(
//                                                              width: 1,
//                                                              height: 54,
//                                                              color: Color.fromRGBO(0, 0, 0, 0.15),
//                                                            ),
//                                                          Expanded(
//                                                            child: RaisedButton(
//                                                              onPressed: (){
//                                                                Navigator.of(context).pop();
//                                                              },
//                                                              elevation: 0.0,
//                                                              color: Color.fromARGB(255, 248, 248, 248),
//                                                              child: Center(
//                                                                child: Text("취소", style: TextStyle(
//                                                                    fontSize: 17, fontWeight: FontWeight.bold,
//                                                                    color: Color.fromARGB(255, 0, 122, 255)
//                                                                ),),
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        ],
//                                                      )
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    "전화걸기",
                                                    style: TextStyle(
                                                        color: mainColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                  onPressed: () {
                                                    launch("tel:0212345678");
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    "취소",
                                                    style: TextStyle(
                                                        color: mainColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        "전화걸기",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: mainColor),
                                      ),
                                    ),
                                  ),
                                  whiteSpaceH(40),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, right: 40),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 120,
                                      child: GridView.count(
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        childAspectRatio: 2,
                                        children: List.generate(
                                            serviceTag.length, (idx) {
                                          return Text(
                                            "#${serviceTag[idx]}",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 122, 122, 122),
                                                fontSize: 12),
                                            textAlign: TextAlign.center,
                                          );
                                        }),
                                        physics: NeverScrollableScrollPhysics(),
                                      ),
                                    ),
                                  ),
                                  whiteSpaceH(20),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "정보 더보기",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: mainColor),
                                      ),
                                    ),
                                  ),
                                  whiteSpaceH(60),
                                  Center(
                                    child: Text(
                                      "인기메뉴",
                                      style: TextStyle(
                                          color: Black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                  ),
                                  menuExist ? whiteSpaceH(30) : whiteSpaceH(40),
                                  menuExist
                                      ? ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, idx) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 8,
                                                  left: 25,
                                                  right: 25),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "${idx + 1}",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 167, 167, 167),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                      flex: 6,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          "#${popularMenuList[idx].menuName}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: Black),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                        width: 60,
                                                        child: Text(
                                                          "먹어본 사람",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      167,
                                                                      167,
                                                                      167),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      numberFormat.format(
                                                          popularMenuList[idx]
                                                              .eatPerson),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                          color: Black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          shrinkWrap: true,
                                          itemCount: popularMenuList.length,
                                        )
                                      : Center(
                                          child: Text(
                                            "아직 메뉴 정보가 부족합니다.",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 122, 122, 122)),
                                          ),
                                        ),
                                  menuExist ? whiteSpaceH(60) : whiteSpaceH(90),
                                  menuExist
                                      ? Center(
                                          child: Text(
                                            "메뉴 더보기",
                                            style: TextStyle(
                                                color: mainColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      : Container(),
                                  menuExist ? whiteSpaceH(60) : Container(),
                                  GestureDetector(
                                    onTap: () {
                                      print("네이버");
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.5),
                                          border: Border.all(
                                              width: 0.2,
                                              color: Color.fromARGB(
                                                  255, 29, 194, 38))),
                                      child: Center(
                                        child: Text(
                                          "네이버로 카페 정보 더 보기",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              color: Color.fromARGB(
                                                  255, 13, 190, 23)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  cafeUserImage
                                      ? whiteSpaceH(80)
                                      : whiteSpaceH(60),
                                  cafeUserImage
                                      ? Column(
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                "총 기록 ${numberFormat.format(allRecord)}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            whiteSpaceH(10),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Text(
                                                  "전체보기",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: mainColor,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            whiteSpaceH(10),
                                            instaCafePost(),
                                            whiteSpaceH(40),
                                            Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  print("사진 더보기");
                                                },
                                                child: Text(
                                                  "사진 더보기",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: mainColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Center(
                                          child: Text(
                                            "아직 사진 정보가 부족합니다.",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 122, 122, 122),
                                                fontSize: 12),
                                          ),
                                        ),
                                  cafeUserImage
                                      ? whiteSpaceH(20)
                                      : whiteSpaceH(70)
                                ],
                              ),
                            ),
                          ),
                          mainImage(),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 15),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: favoriteFab(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15, bottom: 15),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: backFab(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
