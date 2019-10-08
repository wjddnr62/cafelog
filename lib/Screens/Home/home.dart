import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Screens/PopularityCafe/popularityCafe.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  bool filterButton = false;

  BoxDecoration selectFilterDeco =
      BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(16));
  TextStyle selectFilterStyle = TextStyle(color: White, fontSize: 12);
  TextStyle nonSelectFilterStyle =
      TextStyle(color: Color.fromARGB(255, 122, 122, 122), fontSize: 12);

  List<String> tagListItem = [
    "#마카롱",
    "#흑당라떼",
    "#케이크",
    "#베이커리",
    "#레스토랑",
    "#테스트",
    "#테스트2",
    "#테스트3",
    "#테스트4",
    "#테스트5",
    "#테스트6",
    "#테스트7"
  ];

  List<InstaPostData> instaPostLeftData = [];
  List<InstaPostData> instaPostRightData = [];

  BoxDecoration tagDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color.fromARGB(255, 247, 247, 247));

  BoxDecoration tagClickDecoration =
      BoxDecoration(borderRadius: BorderRadius.circular(5), color: mainColor);

  PanelController _panelController = PanelController();

  int upPanelMenuType = 0; // 0 == 홈, 1 == 인기카페, 2 == 내 주변, 3 == 로그인

  final upPanelColor = const Color.fromARGB(255, 219, 219, 219);
  final mainUpPanelText =
      TextStyle(fontSize: 14.0, color: Black, fontWeight: FontWeight.bold);
  final mainUpPanelHoverText =
      TextStyle(fontSize: 14.0, color: mainColor, fontWeight: FontWeight.bold);
  final instaPostDataNameText = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: White,
      shadows: [Shadow(color: Black, blurRadius: 5)]);

  bool keywordSearching = false;
  bool directSearching = false;

  String keyword = "";
  String directKeyword = "";

  int clickNum;

  AppBar searchAppBar;

  int prefsInit = 0;
  SharedPreferences prefs;
  List<String> searchList = [];

  bool keyBoardOn = false;

  TextEditingController _searchController = TextEditingController(text: "");
  FocusNode _searchNode = FocusNode();

  List<String> searchTagList = List();
  bool tagOr = false;

  prefInit() async {
    if (prefsInit == 0) {
      prefs = await SharedPreferences.getInstance();
      prefsInit = 1;
    }

    searchList = prefs.getStringList("searchList");
  }

  prefSet(searchText) async {
    searchList.add(searchText);
    await prefs.setStringList("searchList", searchList);
    prefInit();
  }

  searchChangeText() {
    print("검색 내용 : " + _searchController.text);
  }

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(onChange: (visible) {
      setState(() {
        print(visible);
        keyBoardOn = visible;
      });
    });

    prefInit();

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

  homeAppBar() => AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: White,
        title: GestureDetector(
          onTap: () {
            print("카페 지역 선택");
            Navigator.of(context).pushNamed('/LocationSearch');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "전체카페",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Black),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: mainColor,
                size: 18,
              )
            ],
          ),
        ),
        // bloc 에 카페명 저장하여 관리
        leading: IconButton(
          onPressed: () {
            print("검색");
            setState(() {
              directSearching = true;
            });
          },
          icon: Icon(
            Icons.search,
            color: Color.fromARGB(255, 122, 122, 122),
            size: 30,
          ),
        ),
        actions: <Widget>[whiteSpaceW(MediaQuery.of(context).size.width / 5)],
      );

  searchOrTagList() => ListView.builder(
        itemBuilder: (context, idx) {
          print("iii : " +
              idx.toString() +
              ", " +
              searchTagList.length.toString());
          return idx == searchTagList.length - 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: Text(searchTagList[idx],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: mainColor,
                          )),
                    ),
                    Container(
                      width: 80,
                      child: TextFormField(
                        controller: _searchController,
                        focusNode: _searchNode,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                            fontSize: 14,
                            color: Black,
                            fontWeight: FontWeight.bold),
                        onFieldSubmitted: (value) {
                          if (value == null || value == " ") {
                            _searchController.text = "";
                          } else {
                            setState(() {
                              searchTagList.add(value);
                              _searchController.text = "";
                              FocusScope.of(context).requestFocus(_searchNode);
                            });
                          }

                        },
                        onChanged: (value) {
                          print("value : " + value);
                          if (value == null || value == " ") {
                            _searchController.text = "";
                          } else {
                            if (value.contains(" ")) {
                              setState(() {
                                searchTagList.add(value);
                                _searchController.text = "";
                                FocusScope.of(context)
                                    .requestFocus(_searchNode);
                              });
                            }
                          }
                        },
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 167, 167, 167)),
                            hintText: "키워드 추가",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                      ),
                    )
                  ],
                )
              : Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Center(
                    child: Text(searchTagList[idx],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainColor,
                        )),
                  ),
                );
        },
        itemCount: searchTagList.length,
        scrollDirection: Axis.horizontal,
//        shrinkWrap: true,
      );

  searchingAppBar() => searchAppBar = AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 240, 240, 240)),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 122, 122, 122),
                              size: 34,
                            ),
                          ),
                          // 태그 or list 들어갈 부분
                          tagOr == false
                              ? Expanded(
                                  child: TextFormField(
                                    controller: _searchController,
                                    focusNode: _searchNode,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        searchTagList.add(value);
                                        _searchController.text = "";
                                        tagOr = true;
                                        FocusScope.of(context)
                                            .requestFocus(_searchNode);
                                      });
                                    },
                                    onChanged: (value) {
                                      if (value.contains(" ")) {
                                        setState(() {
                                          searchTagList.add(value);
                                          tagOr = true;
                                          FocusScope.of(context)
                                              .requestFocus(_searchNode);
                                        });
                                      } else {}
                                      print("value : " + value);
                                    },
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 167, 167, 167)),
                                        hintText: "키워드로 카페 기록을 검색해보세요.",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            top: 10, bottom: 10, left: 5)),
                                  ),
                                )
                              : Expanded(
                                  child: searchOrTagList(),
                                )
                        ],
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            directSearching = false;
                          });
                        },
                        child: Container(
                          color: White,
                          child: Text(
                            "취소",
                            style: TextStyle(color: mainColor, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: White,
        elevation: 0.0,
//        title: ,
      );

  tagList() => ListView.builder(
        itemCount: tagListItem.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (clickNum == position) {
                    clickNum = null;
                    keyword = "";
                    keywordSearching = false;
                    // 선택해제
                  } else {
                    clickNum = position;
                    keyword = tagListItem[position];
                    keywordSearching = true;
                    // 선택
                  }
                });
                print("태그 클릭 : " + tagListItem[position]);
              },
              child: Container(
                width: 60,
                height: 30,
                decoration:
                    clickNum == position ? tagClickDecoration : tagDecoration,
                child: Center(
                  child: Text(
                    tagListItem[position],
                    style: clickNum == position
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

  upPanelMenu(menuType, menuName) => menuType == 3
      ? Expanded(
          flex: 2,
          child: upPanelMenuType == menuType
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      upPanelMenuType = menuType;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 30 / 2),
                          child: Text(
                            menuName,
                            style: mainUpPanelHoverText,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.brightness_1,
                            size: 5,
                            color: mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      upPanelMenuType = menuType;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30 / 2),
                            child: Text(
                              menuName,
                              style: mainUpPanelText,
                            ),
                          ),
                        ),
                        whiteSpaceH(10)
                      ],
                    ),
                  ),
                ),
        )
      : Expanded(
          child: upPanelMenuType == menuType
              ? Container(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        upPanelMenuType = menuType;
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 30 / 2),
                            child: Text(
                              menuName,
                              style: mainUpPanelHoverText,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.brightness_1,
                              size: 5,
                              color: mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      upPanelMenuType = menuType;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30 / 2),
                            child: Text(
                              menuName,
                              style: mainUpPanelText,
                            ),
                          ),
                        ),
                        whiteSpaceH(10)
                      ],
                    ),
                  ),
                ),
        );

  slidingUpPanelBody() => SlidingUpPanel(
        controller: _panelController,
        minHeight: keyBoardOn == false ? 60 : 0,
        maxHeight: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height / 6),
        isDraggable: false,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
        border: Border.all(color: upPanelColor, width: 0.1),
        backdropEnabled: false,
        parallaxEnabled: false,
        boxShadow: [BoxShadow(color: Colors.transparent)],
        panel: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        collapsed: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(top: 5.0),
//                child: Container(
//                  width: 50,
//                  height: 5,
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(16.0),
//                    color: Color.fromARGB(255, 216, 216, 216),
//                  ),
//                ),
//              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  children: <Widget>[
                    upPanelMenu(0, "홈"),
                    upPanelMenu(1, "인기카페"),
                    upPanelMenu(2, "내 주변"),
                    upPanelMenu(3, "로그인")
                  ],
                ),
              )
            ],
          ),
        ),
        body: directSearching == false
            ? upPanelMenuType == 1 ? PopularityCafe() : body()
            : searchBody(),
      );

  menuBar(content) => GestureDetector(
        onTap: () {
          if (content == "인기") {
            if (filterButton == true) {
              setState(() {
                filterButton = false;
              });
            }
          } else if (content == "최신") {
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
                  ),
      );

  keywordSearch(keyword) {
    if (keyword != null && keyword != "") {
      return Padding(
        padding: EdgeInsets.only(bottom: 150, left: 35, top: 20),
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
                  "검색하신 키워드로\n기록이 없습니다.",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  instaCafePost() => Padding(
        padding: EdgeInsets.only(top: 20, bottom: 150, left: 15, right: 15),
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
                                style: instaPostDataNameText,
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
                                style: instaPostDataNameText,
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

  body() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: Row(
                children: <Widget>[
                  menuBar("인기"),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: menuBar("최신"),
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
            whiteSpaceH(10),
            keywordSearching == true
                ? whiteSpaceH(MediaQuery.of(context).size.height / 4.5)
                : SizedBox(),
            keywordSearching == false
                ? instaCafePost()
                : keywordSearch(keyword),
          ],
        ),
      );

  search() => GestureDetector(
        onTap: () {
          print("검색하기");
        },
        child: Container(
          width: 123,
          height: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Color.fromARGB(255, 167, 167, 167),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 219, 219, 219), blurRadius: 3)
              ]),
          child: Center(
            child: Text("검색하기",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: White, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      );

  searchBody() => SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        "인기 키워드",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                      padding: EdgeInsets.only(left: 15, top: 20),
                      child: Text(
                        "최근 검색 키워드",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    (searchList == null)
                        ? Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text(
                                "최근 검색한 키워드가 없습니다.",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 158, 154, 154)),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                keyBoardOn == false
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 2),
                        child: Center(
                          child: search(),
                        ),
                      )
                    : Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: search(),
                        ),
                        bottom: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).viewInsets.bottom +
                            20,
                      )
              ],
            )),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        if (directSearching == true) {
          setState(() {
            directSearching = false;
          });
        } else {
          Navigator.of(context).pop();
        }

        return null;
      },
      child: Scaffold(
        appBar: directSearching == false ? homeAppBar() : searchingAppBar(),
        backgroundColor: White,
        resizeToAvoidBottomInset: true,
        body: slidingUpPanelBody(),
      ),
    );
  }
}
