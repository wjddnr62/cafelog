import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Model/morePictureData.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../colors.dart';

class MorePicture extends StatefulWidget {
  @override
  _MorePicture createState() => _MorePicture();
}

class _MorePicture extends State<MorePicture> {
  List<MorePictureData> morePictureLeftData = List();
  List<MorePictureData> morePictureRightData = List();
  List<MorePictureData> typeZeroLeftData = List();
  List<MorePictureData> typeZeroRightData = List();
  List<MorePictureData> typeOneLeftData = List();
  List<MorePictureData> typeOneRightData = List();
  List<MorePictureData> typeTwoLeftData = List();
  List<MorePictureData> typeTwoRightData = List();
  List<MorePictureData> typeThreeLeftData = List();
  List<MorePictureData> typeThreeRightData = List();
  List<int> typeLength = [0, 0, 0, 0];
  int allLength = 0;
  int selectBox = 0;
  int defaultLeftLength = 30;
  int defaultRightLength = 30;
  int maxLength = 60;
  ScrollController _scrollController = ScrollController();
  int addPost = 0;
  int allTagNum = 0;
  List<String> tagName = List();
  List<int> tagLength = List();
  bool tagSelect = false;
  int tagSelectNum = 0;
  String selectTagName = "";

  @override
  void initState() {
    _scrollController.addListener(checkEndList);
    super.initState();

    for (int i = 0; i < maxLength; i++) {
      List<String> image = List();
      if (addPost == 0) {
        addPost = 1;
        if (i >= 15 && i <= 17) {
          image.clear();
          image.add("assets/test/test${1}.png");
          image.add("assets/test/test${2}.png");
          morePictureLeftData
              .add(MorePictureData(image, "@test${i}", "", 2, "마카롱"));
        } else if (i >= 10) {
          image.clear();
          if (i.toString().contains("9")) {
            image.add("assets/test/test${(i).toString().substring(0, 1)}.png");
          } else {
            image.add(
                "assets/test/test${(i + 1).toString().substring(0, 1)}.png");
          }
          morePictureLeftData
              .add(MorePictureData(image, "@test${i}", "", 1, ""));
        } else {
          image.clear();
          if (i.toString().contains("9")) {
            image.add("assets/test/test${(i).toString().substring(0, 1)}.png");
          } else {
            image.add(
                "assets/test/test${(i + 1).toString().substring(0, 1)}.png");
          }
          morePictureLeftData
              .add(MorePictureData(image, "@test${i}", "", 0, ""));
        }
      } else if (addPost == 1) {
        addPost = 0;
        if (i >= 35 && i <= 37) {
          image.clear();
          image.add("assets/test/test${1}.png");
          image.add("assets/test/test${2}.png");
          morePictureRightData
              .add(MorePictureData(image, "@test${i}", "", 3, ""));
        } else if (i >= 10) {
          image.clear();
          if (i.toString().contains("9")) {
            image.add("assets/test/test${(i).toString().substring(0, 1)}.png");
          } else {
            image.add(
                "assets/test/test${(i + 1).toString().substring(0, 1)}.png");
          }
          morePictureRightData
              .add(MorePictureData(image, "@test${i}", "", 2, "흑당라떼"));
        } else {
          image.clear();
          if (i.toString().contains("9")) {
            image.add("assets/test/test${(i).toString().substring(0, 1)}.png");
          } else {
            image.add(
                "assets/test/test${(i + 1).toString().substring(0, 1)}.png");
          }
          morePictureRightData
              .add(MorePictureData(image, "@test${i}", "", 0, ""));
        }
      }
    }
    tagName.clear();

    // type : 0 = 업체사진, 1 = 매장사진, 2 = 메뉴사진, 3 = 카페에서
    for (int i = 0; i < morePictureLeftData.length; i++) {
      if (morePictureLeftData[i].type == 0) {
        typeLength[0] += 1;
      } else if (morePictureLeftData[i].type == 1) {
        typeLength[1] += 1;
      } else if (morePictureLeftData[i].type == 2) {
        typeLength[2] += 1;
        if (tagName.length == 0) {
          tagName.add(morePictureLeftData[i].tag);
        } else {
          int check = 0;
          for (int j = 0; j < tagName.length; j++) {
            if (morePictureLeftData[i].tag != null &&
                morePictureLeftData[i].tag != "") {
              if (tagName[j] == morePictureLeftData[i].tag) {
                check = 1;
                break;
              } else {
//                print("leftTag : " + tagName[i] + ", " + morePictureLeftData[i].tag);
                check = 0;
              }
            }
          }
          if (check == 0) {
            print("addTag : " + morePictureLeftData[i].tag);
            tagName.add(morePictureLeftData[i].tag);
          }
        }
      } else if (morePictureLeftData[i].type == 3) {
        typeLength[3] += 1;
      }
    }

    for (int i = 0; i < morePictureRightData.length; i++) {
      if (morePictureRightData[i].type == 0) {
        typeLength[0] += 1;
      } else if (morePictureRightData[i].type == 1) {
        typeLength[1] += 1;
      } else if (morePictureRightData[i].type == 2) {
        typeLength[2] += 1;
        if (tagName.length == 0) {
          tagName.add(morePictureRightData[i].tag);
        } else {
          int check = 0;
          for (int j = 0; j < tagName.length; j++) {
            if (morePictureRightData[i].tag != null &&
                morePictureRightData[i].tag != "") {
              if (tagName[j] == morePictureRightData[i].tag) {
                check = 1;
                break;
              } else {
//                print("rightTag : " + tagName[i] + ", " + morePictureRightData[i].tag);
                check = 0;
              }
            }
          }
          if (check == 0) {
            print("addTag : " + morePictureRightData[i].tag);
            tagName.add(morePictureRightData[i].tag);
          }
        }
      } else if (morePictureRightData[i].type == 3) {
        typeLength[3] += 1;
      }
    }

    tagLength = List(tagName.length);
    print("tagLength : " +
        tagLength.length.toString() +
        ", " +
        tagName.length.toString());
    for (int i = 0; i < tagLength.length; i++) {
      tagLength[i] = 0;
    }

    for (int i = 0; i < morePictureLeftData.length; i++) {
      for (int j = 0; j < tagName.length; j++) {
        if(tagName[j] == morePictureLeftData[i].tag) {
           tagLength[j] += 1;
        }
      }
    }

    for (int i = 0; i < morePictureRightData.length; i++) {
      for (int j = 0; j < tagName.length; j++) {
        if(tagName[j] == morePictureRightData[i].tag) {
          tagLength[j] += 1;
        }
      }
    }

    for (int i = 0; i < tagLength.length; i++) {
      print("tagLengthCheck : " + tagLength[i].toString());
    }

    for (int i = 0; i < typeLength.length; i++) {
//      print("typeLength : " + typeLength[i].toString());
    }

    setState(() {
      allLength = morePictureLeftData.length + morePictureRightData.length;
    });
  }

  checkEndList() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (defaultLeftLength != morePictureLeftData.length) {
          if ((defaultLeftLength + 10) > morePictureLeftData.length) {
            defaultLeftLength = morePictureLeftData.length;
          } else {
            defaultLeftLength += 10;
          }
        }

        if (defaultRightLength != morePictureRightData.length) {
          if ((defaultRightLength + 10) > morePictureRightData.length) {
            defaultRightLength = morePictureRightData.length;
          } else {
            defaultRightLength += 10;
          }
        }
      });
//      print("bottom");
    }
  }

  leftPost(position) {
//    print("leftPosition : ${position}");
    return GestureDetector(
      onTap: () {
        print("left");
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                child: Image.asset(
                  morePictureLeftData[position].img[0],
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            child: Text(
              morePictureLeftData[position].instaName,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: White,
                  shadows: [Shadow(color: Black, blurRadius: 5)]),
            ),
            bottom: 15,
            left: 5,
          ),
          morePictureLeftData[position].img.length == 2
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

  rightPost(position) {
    return GestureDetector(
      onTap: () {
        print("right");
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                morePictureRightData[position].img[0],
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            child: Text(
              morePictureRightData[position].instaName,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: White,
                  shadows: [Shadow(color: Black, blurRadius: 5)]),
            ),
            bottom: 15,
            left: 5,
          ),
          morePictureRightData[position].img.length == 2
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

  instaCafePost() => Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Container(
          width: MediaQuery.of(context).size.width,
//          height: MediaQuery.of(context).size.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: defaultLeftLength,
                  itemBuilder: (context, position) {
//                    print("checkPosition : ${position}, ${defaultLeftLength}");
//                    print("selectBoxLeft : ${selectBox}");
                    if (selectBox != 0) {
                      if (selectBox - 1 == morePictureLeftData[position].type) {
//                        print("check2 : ${selectBox - 1}, ${morePictureLeftData[position].type}");
                        if (selectBox - 1 == 2) {
                          if (tagSelect && (selectTagName == morePictureLeftData[position].tag)) {
                            if (defaultLeftLength != position) {
                              return rightPost(position);
                            }
                          } else if (!tagSelect) {
                            if (defaultLeftLength != position) {
                              return rightPost(position);
                            }
                          }
                        } else {
                          if (defaultLeftLength != position) {
                            return rightPost(position);
                          }
                        }
                      }
                    } else {
//                      print("check");
//                      print("check : " + defaultLeftLength.toString() + ", " + position.toString());
                      if (defaultLeftLength != position) {
                        return leftPost(position);
                      }
                    }

                    return Container();
                  },
                ),
              ),
              whiteSpaceW(15),
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: defaultRightLength,
                  itemBuilder: (context, position) {
//                    print("selectBoxRight : ${position}, ${morePictureRightData[position].type}");
                    if (selectBox != 0) {
//                      print("check3 : ${selectBox - 1}, type : ${morePictureRightData[position].type}");
                      if (selectBox - 1 ==
                          morePictureRightData[position].type) {
                        if (selectBox - 1 == 2) {
                          if (tagSelect && (selectTagName == morePictureRightData[position].tag)) {
                            if (defaultRightLength != position) {
                              return rightPost(position);
                            }
                          } else if (!tagSelect) {
                            if (defaultRightLength != position) {
                              return rightPost(position);
                            }
                          }
                        } else {
                          if (defaultRightLength != position) {
                            return rightPost(position);
                          }
                        }
                      }
                    } else {
                      if (defaultRightLength != position) {
                        return rightPost(position);
                      }
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      );

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
        controller: _scrollController,
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
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, idx) {
                          if (idx == 0) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectBox = idx;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: selectBox == idx
                                          ? mainColor
                                          : Color.fromARGB(255, 240, 240, 240),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                    "전체(${allLength})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                            selectBox == idx ? White : Black),
                                  )),
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectBox = idx;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: selectBox == idx
                                          ? mainColor
                                          : Color.fromARGB(255, 240, 240, 240),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                    idx == 1
                                        ? "업체사진(${typeLength[idx - 1]})"
                                        : idx == 2
                                            ? "매장사진(${typeLength[idx - 1]})"
                                            : idx == 3
                                                ? "메뉴사진(${typeLength[idx - 1]})"
                                                : idx == 4
                                                    ? "카페에서(${typeLength[idx - 1]})"
                                                    : "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                            selectBox == idx ? White : Black),
                                  )),
                                ),
                              ),
                            );
                          }
                        },
                        shrinkWrap: true,
                        itemCount: 5,
                      ),
                    ),
                    whiteSpaceW(10)
                  ],
                ),
              ),
              selectBox == 3 ? whiteSpaceH(10) : Container(),
              selectBox == 3 ? Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 30,
                child: ListView.builder(itemBuilder: (context, idx) {
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
                        decoration: tagSelect ? tagSelectNum == idx ? BoxDecoration(
                            color: Color.fromARGB(255, 247, 247, 247),
                            borderRadius: BorderRadius.circular(15)
                        ) : BoxDecoration(
                            color: White
                        ) : BoxDecoration(
                            color: White
                        ),
//                        width: 80,
                        height: 30,
                        child: Center(
                          child: Text("#${tagName[idx]}(${tagLength[idx]})", style: TextStyle(
                              color: tagSelect ? tagSelectNum == idx ? Black : Color.fromARGB(255, 167, 167, 167) : Color.fromARGB(255, 167, 167, 167),
                              fontSize: 12,
                              fontWeight: FontWeight.w600
                          ),),
                        ),
                      ),
                    ),
                  );
                }, shrinkWrap: true, itemCount: tagName.length, scrollDirection: Axis.horizontal,),
              ) : Container(),
              instaCafePost(),
              whiteSpaceH(10)
            ],
          ),
        ),
      ),
    );
  }
}
