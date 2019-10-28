import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/popularityCafeData.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';

class PopularityCafe extends StatefulWidget {
  String cafeLocation;

  PopularityCafe({Key key, this.cafeLocation}) : super(key: key);

  @override
  _PopularityCafe createState() => _PopularityCafe();
}

class _PopularityCafe extends State<PopularityCafe> {
  MainBloc _mainBloc = MainBloc();

  bool filterButton = false;

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

  String cafeLocation;
  List<PopularityCafeData> _cafeList = List();

  @override
  void initState() {
    super.initState();

    setState(() {
      cafeLocation = widget.cafeLocation;
      _mainBloc.setStreet(cafeLocation);
      print(cafeLocation);
    });

    for (int i = 0; i < tagListItem.length; i++) {
      tagClick.add(false);
    }
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

  menuBar(content) => GestureDetector(
        onTap: () {
          if (content == "인기") {
            if (filterButton == true) {
              setState(() {
                filterButton = false;
              });
            }
          } else if (content == "최근 핫플") {
            if (filterButton == false) {
              setState(() {
                filterButton = true;
              });
            }
          }
        },
        child: content == "인기"
            ? filterButton == false
                ? Container(
                    decoration: selectFilterDeco,
                    width: 50,
                    height: 30,
                    child: Center(
                      child: Text(
                        content,
                        style: selectFilterStyle,
                      ),
                    ),
                  )
                : Container(
                    width: 50,
                    height: 30,
                    color: White,
                    child: Center(
                      child: Text(
                        content,
                        style: nonSelectFilterStyle,
                      ),
                    ),
                  )
            : filterButton == true
                ? Container(
                    decoration: selectFilterDeco,
                    width: 70,
                    height: 30,
                    child: Center(
                      child: Text(
                        content,
                        style: selectFilterStyle,
                      ),
                    ),
                  )
                : Container(
                    width: 70,
                    height: 30,
                    color: White,
                    child: Center(
                      child: Text(
                        content,
                        style: nonSelectFilterStyle,
                      ),
                    ),
                  ),
      );

  cafeList() => StreamBuilder(
        stream: _mainBloc.getPopularityCafe(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> valueList =
                json.decode(snapshot.data)['data']['cafes'];
            _cafeList.clear();

            for (int i = 0; i < valueList.length; i++) {
              _cafeList.add(PopularityCafeData(
                  picture: valueList[i]['picture'],
                  name: valueList[i]['name'],
                  userNum: valueList[i]['user_num'],
                  recentNum: valueList[i]['recent_num']));
            }

            if (_cafeList != null &&
                _cafeList.isNotEmpty &&
                _cafeList.length >= 0) {
              return Padding(
                padding: EdgeInsets.only(top: 15, bottom: 60),
                child: ListView.builder(
                  itemBuilder: (context, idx) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/CafeDetail');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "${idx + 1}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color.fromARGB(255, 167, 167, 167)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15,),
                                child: Stack(
                                  children: <Widget>[
//                                  Positioned(
//                                    left: 15,
//                                    right: 1,
//                                    top: 1,
//                                    bottom: 1,
//                                    child:
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 44,
                                        decoration: BoxDecoration(
                                            color: White,
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 219, 219, 219),
                                                  blurRadius: 7)
                                            ]),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 30),
                                              child: Container(
                                                width: 110,
                                                child: Text(
                                                  _cafeList[idx].name,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Black),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: 50,
                                                child: Text(
                                                  "다녀온 사람",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 167, 167, 167),
                                                      fontSize: 10,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  _cafeList[idx]
                                                      .userNum
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 10,
                                                      color: Black),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Container(
                                                  width: 35,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Center(
                                                        child: Text(
                                                          "최근1주일",
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              color: mainColor),
                                                        ),
                                                      ),
                                                      whiteSpaceH(1),
                                                      Center(
                                                        child: Text(
                                                          _cafeList[idx]
                                                              .recentNum
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: mainColor,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 8),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
//                                  ),
                                    Positioned(
                                      top: 2,
                                      child: CachedNetworkImage(
                                        imageUrl: _cafeList[idx].picture,
                                        imageBuilder: (context, imageProvider) =>
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                              child: Image(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
//                                        placeholder: (context, url) => ClipRRect(
//                                          borderRadius: BorderRadius.circular(8.0),
//                                          child: Image.asset("assets/defaultImage.png", width: 40, height: 40, fit: BoxFit.fill,),
//                                        ),
                                        errorWidget: (context, url, error) => ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.asset("assets/defaultImage.png", width: 40, height: 40, fit: BoxFit.fill,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    );
                  },
                  shrinkWrap: true,
                  itemCount: _cafeList.length,
                ),
              );
            }
          }
          return Container(
            width: 50,
            height: 50,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, top: 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                menuBar("인기"),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 5),
                  child: menuBar("최근 핫플"),
                ),
                Expanded(
                  child: Align(
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
                          width: 90,
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
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 170,
              child: cafeList(),
            ),
        ],
      ),
    );
  }
}
