import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/cafeListData.dart';
import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Model/morePictureData.dart';
import 'package:cafelog/Screens/Home/instaDetail.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../colors.dart';

class MorePicture extends StatefulWidget {
  String cafeName;

  MorePicture({Key key, this.cafeName}) : super(key: key);

  @override
  _MorePicture createState() => _MorePicture();
}

class _MorePicture extends State<MorePicture> {
//  List<MorePictureData> morePictureData = List();

  List<CafeListData> cafelistData = List();

//  List<MorePictureData> typeZeroData = List();
//  List<MorePictureData> typeOneData = List();
//  List<MorePictureData> typeTwoData = List();
//  List<MorePictureData> typeThreeData = List();

  List<int> typeLength = [0, 0, 0, 0];
  int allLength = 0;
  int selectBox = 0;

  int defaultOffSet = 0;

  int defaultLength = 30;

  ScrollController _scrollController = ScrollController();
  int addPost = 0;
  int allTagNum = 0;
  List<String> tagName = List();
  List<int> tagLength = List();
  bool tagSelect = false;
  int tagSelectNum = 0;
  String selectTagName = "";
  bool firstData = false;
  int allRecord = 0;

  @override
  void initState() {
    _scrollController.addListener(checkEndList);
    super.initState();

    mainBloc.setRecodeTag(widget.cafeName);
    mainBloc.getCafeRecodeCount().then((value) {
      setState(() {
        allRecord = json.decode(value)['data'];
      });
    });

    tagName.clear();

    // type : 0 = 업체사진, 1 = 매장사진, 2 = 메뉴사진, 3 = 카페에서
//    for (int i = 0; i < morePictureData.length; i++) {
//      if (morePictureData[i].type == 0) {
//        typeLength[0] += 1;
//      } else if (morePictureData[i].type == 1) {
//        typeLength[1] += 1;
//      } else if (morePictureData[i].type == 2) {
//        typeLength[2] += 1;
//        if (tagName.length == 0) {
//          tagName.add(morePictureData[i].tag);
//        } else {
//          int check = 0;
//          for (int j = 0; j < tagName.length; j++) {
//            if (morePictureData[i].tag != null &&
//                morePictureData[i].tag != "") {
//              if (tagName[j] == morePictureData[i].tag) {
//                check = 1;
//                break;
//              } else {
////                print("leftTag : " + tagName[i] + ", " + morePictureLeftData[i].tag);
//                check = 0;
//              }
//            }
//          }
//          if (check == 0) {
//            print("addTag : " + morePictureData[i].tag);
//            tagName.add(morePictureData[i].tag);
//          }
//        }
//      } else if (morePictureData[i].type == 3) {
//        typeLength[3] += 1;
//      }
//    }

//    tagLength = List(tagName.length);
//    print("tagLength : " +
//        tagLength.length.toString() +
//        ", " +
//        tagName.length.toString());
//    for (int i = 0; i < tagLength.length; i++) {
//      tagLength[i] = 0;
//    }
//
//    for (int i = 0; i < morePictureData.length; i++) {
//      for (int j = 0; j < tagName.length; j++) {
//        if (tagName[j] == morePictureData[i].tag) {
//          tagLength[j] += 1;
//        }
//      }
//    }

//    setState(() {
//      allLength = morePictureData.length;
//    });

    mainBloc.setLimit(0);
    mainBloc.setName(widget.cafeName);
  }

  checkEndList() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        firstData = false;
      });
//      print("bottom");
    }
  }

  mainListGrid() {
    if (!firstData) {
      print("defaultOffSet : ${defaultOffSet}");
      mainBloc.setLimit(defaultOffSet);

      mainBloc.getMorePicture().then((value) async {
        if (json.decode(value)['result'] != 0 &&
            (json.decode(value)['data'] != null &&
                json.decode(value)['data'] != "")) {
          if (!firstData) {
            defaultOffSet += 3;
            print('value : ${json.decode(value)['data']}');
            List<dynamic> valueList = await json.decode(value)['data'];
            print(valueList.length);
            if (valueList.length != 0) {
              for (int i = 0; i < valueList.length; i++) {
                cafelistData.add(CafeListData(
                    url: valueList[i]['url'],
                    nickname: valueList[i]['nickname'],
                    pic: valueList[i]['pic'],
                    date: valueList[i]['date'],
                    like: valueList[i]['like'],
                    search_tag: valueList[i]['search_tag']));
              }
            }
            firstData = true;
          }
          setState(() {});
        }
      }).catchError((error) {
        print("error : ${error}");
      });
    }
    return (cafelistData.length == 0 && firstData == false)
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: StaggeredGridView.countBuilder(
              controller: _scrollController,
              crossAxisCount: 2,
              shrinkWrap: true,
              itemCount: cafelistData.length,
              itemBuilder: (context, idx) => GestureDetector(
                onTap: () {
                  print("Name : ${cafelistData[idx].search_tag}");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstaDetail(
                          name: cafelistData[idx].search_tag,
                          instaUrl: cafelistData[idx].url,
                          offset: _scrollController.offset,
                          type: 1,
                        ),
                      )).then((result) {
                    _scrollController.animateTo(result,
                        duration: null, curve: null);
                  });
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: cafelistData[idx].pic,
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/defaultImage.png",
                                fit: BoxFit.fill,
                              ),
                            )),
                      ),
                    ),
                    Positioned(
                      child: Text(
                        "@" + cafelistData[idx].nickname,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: White,
                            shadows: [Shadow(color: Black, blurRadius: 5)]),
                      ),
                      bottom: 20,
                      left: 15,
                    ),
                  ],
                ),
              ),
              staggeredTileBuilder: (idx) => StaggeredTile.fit(1),
              crossAxisSpacing: 10.0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
      backgroundColor: White,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
//        controller: _scrollController,
//        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              whiteSpaceH(10),
              Center(
                child: Text(
                  "카페사진",
                  style: TextStyle(
                      fontSize: 18, color: Black, fontWeight: FontWeight.bold),
                ),
              ),
              whiteSpaceH(10),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: Row(
                  children: <Widget>[
                    whiteSpaceW(10),
                    GestureDetector(
                      onTap: () {
//                      setState(() {
//                        selectBox = idx;
//                      });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text(
                            "전체(${allRecord})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: White),
                          )),
                        ),
                      ),
                    ),
                    whiteSpaceW(10)
                  ],
                ),
              ),
              selectBox == 3 ? whiteSpaceH(10) : Container(),
              selectBox == 3
                  ? Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 30,
                      child: ListView.builder(
                        itemBuilder: (context, idx) {
                          return Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!tagSelect) {
                                    tagSelect = true;
                                    tagSelectNum = idx;
                                    selectTagName = tagName[idx];
                                  } else {
                                    tagSelect = false;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 7, right: 7),
                                decoration: tagSelect
                                    ? tagSelectNum == idx
                                        ? BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 247, 247, 247),
                                            borderRadius:
                                                BorderRadius.circular(15))
                                        : BoxDecoration(color: White)
                                    : BoxDecoration(color: White),
//                        width: 80,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    "#${tagName[idx]}(${tagLength[idx]})",
                                    style: TextStyle(
                                        color: tagSelect
                                            ? tagSelectNum == idx
                                                ? Black
                                                : Color.fromARGB(
                                                    255, 167, 167, 167)
                                            : Color.fromARGB(
                                                255, 167, 167, 167),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: tagName.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                  : Container(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80,
                child: mainListGrid(),
              ),
              whiteSpaceH(10)
            ],
          ),
        ),
      ),
    );
  }
}
