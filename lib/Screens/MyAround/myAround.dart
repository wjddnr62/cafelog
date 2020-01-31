import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/myAroundData.dart';
import 'package:cafelog/Screens/PopularityCafe/cafeDetail.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';
import 'package:cafelog/colors.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyAround extends StatefulWidget {
  String tag;

  MyAround({Key key, this.tag}) : super(key: key);

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
  LatLng _latLng;

  List<String> km = List();

  getLocation() async {
    currentLocation = await location.getLocation();
  }

  Future<String> getDistance(cafeAddress) async {
    var address = await Geocoder.local.findAddressesFromQuery(cafeAddress);
    var first = address.first;

    final coordinates = first.coordinates;

    _latLng = LatLng(coordinates.latitude, coordinates.longitude);

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
                    setState(() {
                      print("positionClick : ${position}");
                      tagSelectList.add(tagListItem[position]);
                      firstData = false;
                    });
                    String tag = "";
                    if (tagSelectList.length > 0) {
                      for (int i = 0; i < tagSelectList.length; i++) {
                        if (tagSelectList.length == 1) {
                          tag += tagSelectList[i];
                        } else if (i == tagSelectList.length) {
                          tag += tagSelectList[i];
                        } else {
                          tag += tagSelectList[i] + ",";
                        }
                      }
                    }
                    mainBloc.setMyAroundTag(tag);
                    mainBloc.tagDefaultItem = tagListItem;
                    mainBloc.tagSave = widget.tag;
                    mainBloc.tagSelectList = tagSelectList;
                    mainBloc.tagClick = tagClick;
                    cafeMyAround();
                    // 선택
                  } else {
                    tagClick[position] = false;
                    setState(() {
                      print("position : ${position}");

                      for (int i = 0; i < tagSelectList.length; i++) {
                        if (tagListItem[position] == tagSelectList[i]) {
                          tagSelectList.removeAt(i);
                          break;
                        }
                      }
//                      print("selectTag ${tagSelectList[position]}");

                      firstData = false;
                    });
                    String tag = "";
                    if (tagSelectList.length > 0) {
                      for (int i = 0; i < tagSelectList.length; i++) {
                        if (tagSelectList.length == 1) {
                          tag += tagSelectList[i];
                        } else if (i == tagSelectList.length) {
                          tag += tagSelectList[i];
                        } else {
                          tag += tagSelectList[i] + ",";
                        }
                      }
                    }
                    mainBloc.setMyAroundTag(tag);
                    mainBloc.tagDefaultItem = tagListItem;
                    mainBloc.tagSave = widget.tag;
                    mainBloc.tagSelectList = tagSelectList;
                    mainBloc.tagClick = tagClick;
                    cafeMyAround();
                    // 선택해제
                  }
                });
                print("태그 클릭 : " + tagListItem[position]);
              },
              child: Container(
//                width: 60,
                padding: EdgeInsets.only(left: 10, right: 10),
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

  bool firstData = false;
  bool getData = false;

  cafeMyAround() {
    print("cafeMyAround");
    int valueLength = 0;
    if (!firstData) {
      print("checkFirst");

        mainBloc.getMyAround().then((value) async {
          aroundData.clear();
          km.clear();
          print("jsonDecode : ${json.decode(value)['data']}");
          if (json.decode(value)['result'] != 0 &&
              (json.decode(value)['data'] != null &&
                  json.decode(value)['data'] != null &&
                  json.decode(value)['data'].length != 0)) {
            List<dynamic> valueList = await json.decode(value)['data'];

            if (valueList.length != 0) {
              valueLength = valueList.length;
              print("values : ${json.decode(value)['data']}");
              print("valueLength : ${valueList.length}");
              for (int i = 0; i < valueList.length; i++) {
                String category = "";
                List<String> categorySplit;
                if (valueList[i]['category'].toString().contains(",")) {
                  categorySplit = valueList[i]['category'].toString().split(",");
                  for (int i = 0; i < categorySplit.length; i++) {
                    if (i < 3) {
                      category += categorySplit[i] + "·";
                    }
                  }
                  category = category.substring(0, category.length - 1);
                } else {
                  category = valueList[i]['category'];
                }
                aroundData.add(MyAroundData(
                  user_num: valueList[i]['user_num'],
                  pic: valueList[i]['pic'],
                  convenien: valueList[i]['convenien'],
                  homepage: valueList[i]['homepage'],
                  menu: valueList[i]['menu'],
                  opentime: valueList[i]['opentime'],
                  addr: valueList[i]['addr'],
                  category: category,
                  phone: valueList[i]['phone'],
                  subname: valueList[i]['subname'],
                  name: valueList[i]['name'],
                  url: valueList[i]['url'],
                ));

                await getDistance(valueList[i]['addr']).then((value) async {
                  print("distance : ${value}");
                  setState(() {
                    km.add(value);
                  });
                });
              }
//            setState(() {
//
//            });
              print("aroudnLength : ${aroundData.length}");
              print("Gps Check : ${gpsOn}");
              setState(() {
                firstData = true;
                getData = true;
              });

//            setState(() {});
            }
          } else {
            setState(() {
              firstData = true;
            });
          }
        }).catchError((error) {
          print("aroundError : ${error}");
        });

    }
    return (firstData == false && getData == false)
        ? Padding(
            padding: EdgeInsets.only(left: 35, bottom: 150),
            child: Container(
//          color: Black,
              width: MediaQuery.of(context).size.width,
//          height: MediaQuery.of(context).size.height,
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
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "카페 기록을\n검색 중입니다.",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          )
        : (firstData == true && getData == true)
            ? Padding(
                padding: EdgeInsets.only(left: 15, top: 15, bottom: 150),
                child: ListView.builder(
                  itemBuilder: (context, idx) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CafeDetail(
                              cafeName: aroundData[idx].name,
                              phone: aroundData[idx].phone,
                              identify: aroundData[idx].identify,
                              address: aroundData[idx].addr,
                              convenien: aroundData[idx].convenien,
                              distance: km[idx],
                              imgUrl: aroundData[idx].pic,
                              menu: aroundData[idx].menu,
                              naverUrl: aroundData[idx].url,
                              subName: aroundData[idx].subname,
                              latLng: _latLng,
                              openTime: aroundData[idx].opentime,
                            ),
                          ));
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 10, top: 5, right: 15),
                          child: Stack(
                            children: <Widget>[
                              (aroundData[idx].pic != null &&
                                      aroundData[idx].pic != "")
                                  ? Positioned(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 75),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 150,
                                            padding: EdgeInsets.only(
                                                left: 60, right: 10),
                                            decoration: BoxDecoration(
                                              color: White,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                        255, 167, 167, 167),
                                                    blurRadius: 8)
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  whiteSpaceH(10),
                                                  AutoSizeText(
                                                    aroundData[idx]
                                                        .name,
                                                    maxLines: 1,
                                                    minFontSize: 12,
                                                    style: TextStyle(
                                                      color: Black,
                                                      fontSize: 22,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Text(aroundData[idx].category, style: TextStyle(
                                                            color: Color.fromARGB(255, 167, 167, 167), fontSize: 12
                                                          ),),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: gpsOn
                                                              ? km.length != 0
                                                                  ? Text(
                                                                      "${km[idx]}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Black),
                                                                    )
                                                                  : Container()
                                                              : Container(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
//                                          whiteSpaceH(20),
//                                          Row(
//                                            children: <Widget>[
//                                              Expanded(
//                                                child: Container(
//                                                  width: MediaQuery.of(context)
//                                                      .size
//                                                      .width,
//                                                ),
//                                              ),
//                                              Text(
//                                                aroundData[idx].openCheck == 1
//                                                    ? "영업중"
//                                                    : "영업종료",
//                                                style: TextStyle(
//                                                    fontWeight: FontWeight.w600,
//                                                    fontSize: 10,
//                                                    color: aroundData[idx]
//                                                                .openCheck ==
//                                                            1
//                                                        ? mainColor
//                                                        : Color.fromARGB(
//                                                            255, 53, 159, 255)),
//                                              )
//                                            ],
//                                          ),
//                                          whiteSpaceH(30),
                                                  RichText(
                                                    text: TextSpan(
                                                        text: "다녀온 사람 ",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    167,
                                                                    167,
                                                                    167),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "${aroundData[idx].user_num}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  color: Black))
                                                        ]),
                                                  ),
//                                          whiteSpaceH(5),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      aroundData[idx].addr,
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: White,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 167, 167, 167),
                                                  blurRadius: 8)
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                whiteSpaceH(10),
                                                Text(
                                                  aroundData[idx].name,
                                                  style: TextStyle(
                                                    color: Black,
                                                    fontSize: 22,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        aroundData[idx].category
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: gpsOn
                                                          ? km.length != 0
                                                              ? Text(
                                                                  "${km[idx]}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          Black),
                                                                )
                                                              : Container()
                                                          : Container(),
                                                    )
                                                  ],
                                                ),
                                                whiteSpaceH(20),
//                                        Row(
//                                          children: <Widget>[
//                                            Expanded(
//                                              child: Container(
//                                                width: MediaQuery.of(context)
//                                                    .size
//                                                    .width,
//                                              ),
//                                            ),
//                                            Text(
//                                              aroundData[idx].openCheck == 1
//                                                  ? "영업중"
//                                                  : "영업종료",
//                                              style: TextStyle(
//                                                  fontWeight: FontWeight.w600,
//                                                  fontSize: 10,
//                                                  color: aroundData[idx]
//                                                              .openCheck ==
//                                                          1
//                                                      ? mainColor
//                                                      : Color.fromARGB(
//                                                          255, 53, 159, 255)),
//                                            )
//                                          ],
//                                        ),
                                                whiteSpaceH(30),
                                                RichText(
                                                  text: TextSpan(
                                                      text: "다녀온 사람 ",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              167,
                                                              167,
                                                              167),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                "${aroundData[idx].user_num}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                                color: Black))
                                                      ]),
                                                ),
                                                whiteSpaceH(5),
                                                Expanded(
                                                  child: Text(
                                                    aroundData[idx].addr,
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
                              (aroundData[idx].pic != null &&
                                      aroundData[idx].pic != "")
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 167, 167, 167),
                                                blurRadius: 7)
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          child: FadeInImage(
                                            image: NetworkImage(
                                              aroundData[idx].pic,
                                            ),
                                            placeholder: AssetImage(
                                                "assets/defaultImage.png"),
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ));
                  },
                  shrinkWrap: true,
//              physics: NeverScrollableScrollPhysics(),
                  itemCount: aroundData.length,
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 35, bottom: 150),
                child: Container(
//          color: Black,
                  width: MediaQuery.of(context).size.width,
//          height: MediaQuery.of(context).size.height,
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
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "내 주변에 카페 기록\n없습니다.",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              );
  }

  tagSet() {
    print("length : " + widget.tag.length.toString());
    if (widget.tag.contains(",")) {
      print("split");
      List<String> tagSplit = widget.tag.split(",");
      setState(() {
        for (int i = 0; i < tagSplit.length; i++) {
          tagListItem.insert(i, tagSplit[i]);
          tagSelectList.add(tagListItem[i]);
          tagClick.clear();
        }
        mainBloc.tagDefaultItem = tagListItem;
        mainBloc.tagSelectList = tagSelectList;
        for (int i = 0; i < tagListItem.length; i++) {
          tagClick.add(false);
        }
        for (int i = 0; i < tagSplit.length; i++) {
          tagClick[i] = true;
        }
        mainBloc.tagClick = tagClick;
        mainBloc.tagSave = widget.tag;
        firstData = false;
      });
    } else {
      print("notSplit");
      setState(() {
        tagListItem.insert(0, widget.tag);
        tagSelectList.add(tagListItem[0]);
        tagClick.clear();
        for (int i = 0; i < tagListItem.length; i++) {
          tagClick.add(false);
        }
        tagClick[0] = true;
        mainBloc.tagDefaultItem = tagListItem;
        mainBloc.tagSelectList = tagSelectList;
        mainBloc.tagClick = tagClick;
        mainBloc.tagSave = widget.tag;
        firstData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (mainBloc.tagSave != null && mainBloc.tagSave != "") {
      widget.tag = mainBloc.tagSave;
    }

    if (widget.tag.isNotEmpty) {
      print("widget.tags : ${widget.tag}");
      if (widget.tag.substring(widget.tag.length - 1).contains(",")) {
        widget.tag = widget.tag.substring(0, widget.tag.length - 1);
        tagSet();
      } else {
        tagSet();
      }
    }

    mainBloc.setMyAroundTag(widget.tag);

    gpsCheck();

    getLocation();

    for (int i = 0; i < tagListItem.length; i++) {
      tagClick.add(false);
    }

    if (mainBloc.tagDefaultItem != null &&
        mainBloc.tagDefaultItem.length != 0) {
      tagListItem = mainBloc.tagDefaultItem;
    }

    if (mainBloc.tagClick != null && mainBloc.tagDefaultItem.length != 0) {
      tagClick = mainBloc.tagClick;
    }

    if (mainBloc.tagSelectList != null && mainBloc.tagDefaultItem.length != 0) {
      tagSelectList = mainBloc.tagSelectList;
    }

    mainBloc.tagSelectList = tagSelectList;
    mainBloc.tagDefaultItem = tagListItem;
    mainBloc.tagClick = tagClick;
    mainBloc.tagSave = widget.tag;

    setState(() {
      print('firstDataFalse');
      firstData = false;
      getData = false;
    });

    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
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
//                Align(
//                  alignment: Alignment.centerRight,
//                  child: Padding(
//                    padding: EdgeInsets.only(top: 5, right: 15),
//                    child: GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          if (visitCafe) {
//                            visitCafe = false;
//                          } else {
//                            visitCafe = true;
//                          }
//                        });
//                      },
//                      child: Container(
//                        width: 100,
//                        height: 30,
//                        decoration: BoxDecoration(
//                          color: visitCafe == false
//                              ? White
//                              : Color.fromARGB(255, 240, 240, 240),
//                          borderRadius: BorderRadius.circular(16),
//                        ),
//                        child: Center(
//                          child: Text(
//                            "다녀온카페 제외",
//                            style: visitCafe == false
//                                ? TextStyle(
//                                    color: Color.fromARGB(255, 122, 122, 122),
//                                    fontWeight: FontWeight.w600,
//                                    fontSize: 12)
//                                : TextStyle(
//                                    color: Black,
//                                    fontSize: 12,
//                                    fontWeight: FontWeight.bold),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                )
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
//          Padding(
//            padding: EdgeInsets.only(left: 15, top: 15, right: 15),
//            child: Align(
//              alignment: Alignment.centerRight,
//              child: RichText(
//                text: TextSpan(
//                    text: '* 제휴 할인 : ',
//                    style: TextStyle(
//                        fontSize: 10,
//                        fontWeight: FontWeight.w600,
//                        color: Color.fromARGB(255, 167, 167, 167)),
//                    children: <TextSpan>[
//                      TextSpan(
//                        text: "전용 텀블러",
//                        style: TextStyle(
//                            fontSize: 10,
//                            fontWeight: FontWeight.w600,
//                            color: mainColor),
//                      ),
//                      TextSpan(
//                        text: "로 테이크아웃 시 적용",
//                        style: TextStyle(
//                            fontSize: 10,
//                            fontWeight: FontWeight.w600,
//                            color: Color.fromARGB(255, 167, 167, 167)),
//                      )
//                    ]),
//              ),
//            ),
//          ),
          (aroundData.length == 0 && firstData == false)
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(left: 15, top: 20, bottom: 10),
                  child: Text(
                    "일반카페",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 63, 61, 61),
                        fontSize: 24),
                  ),
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 125,
            child: cafeMyAround(),
          ),
        ],
      ),
    );
  }
}
