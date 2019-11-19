import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/autoTagData.dart';
import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Screens/CafeLocationSearch/locationSearch.dart';
import 'package:cafelog/Screens/MyAround/myAround.dart';
import 'package:cafelog/Screens/PopularityCafe/popularityCafe.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/Widgets/snackbar.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

customErrorWidget(context, error) {
  return Container();
}

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  MainBloc _mainBloc = MainBloc();

  bool filterButton = false;

  BoxDecoration selectFilterDeco =
      BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(16));
  TextStyle selectFilterStyle = TextStyle(color: White, fontSize: 12);
  TextStyle nonSelectFilterStyle =
      TextStyle(color: Color.fromARGB(255, 122, 122, 122), fontSize: 12);

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

  List<InstaPostData> instaPostLeftData = [];
  List<InstaPostData> instaPostRightData = [];
  List<InstaPostData> instaPostData = [];

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
  List<String> searchList;

  bool keyBoardOn = false;

  TextEditingController _searchController = TextEditingController(text: "");
  FocusNode _searchNode = FocusNode();

  List<String> searchTagList = List();
  bool tagOr = false;
  bool addKeyWord = false;

  List<AutoTag> autoTagList = List();
  bool autoTag = false;

  ScrollController _scrollController;

  bool searchEnable = false;

  bool cafeSelect = true;
  String cafeLocation = "전체카페";

  prefInit() async {
    if (prefsInit == 0) {
      prefs = await SharedPreferences.getInstance();
      prefsInit = 1;
    }

    if (prefs.getStringList("searchList") != null &&
        prefs.getStringList("searchList").isNotEmpty)
      setState(() {
        searchList = prefs.getStringList("searchList");
      });
  }

  prefSet() async {
    await prefs.setStringList("searchList", searchList);
    prefInit();
  }

  prefSetValue(searchText) async {
    setState(() {
      searchList.add(searchText);
    });
    await prefs.setStringList("searchList", searchList);
    prefInit();
  }

  searchChangeText() {
    print("검색 내용 : " + _searchController.text.length.toString());
  }

  lastTagMove() {
//    if (_scrollController.hasClients)
    print("test");
    print(searchTagList.length.toString());
    if (searchTagList.length > 0) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  setSearchEnable(value) {
    if (value.length > 0) {
      setState(() {
        searchEnable = true;
      });
    } else if (value.length == 0) {
      setState(() {
        searchEnable = false;
      });
    }
  }

  addTagList(value) {
    searchTagList.add(value);
    print("listLength : " + searchTagList.length.toString());
    if (searchTagList.length > 0) {
      setState(() {
        searchEnable = true;
      });
    }
  }

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

  var currentLocation;
  var location = new Location();
  var address;
  String userLocation = "";

  getLocation() async {
    try {
      currentLocation = await location.getLocation();
      final coordinates = new Coordinates(currentLocation.latitude, currentLocation.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      address = addresses.first;
      print("${address.featureName}, ${address.addressLine}");
      List<String> lines = address.addressLine.toString().split(" ");
        setState(() {
          userLocation = "";
          for (int i = 0; i < lines.length; i++) {
            print("lines : ${lines[i]}");
            if (lines[i].contains("구")) {
              userLocation += lines[i];
            } else if (lines[i].contains("로")) {
              userLocation += " " + lines[i];
            }
          }
        });
    } on Exception catch(e) {
      getLocation();
    }

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
//    cal();

    searchList = List();

    _scrollController = ScrollController();

    _searchController = TextEditingController(text: "");
    _searchNode = FocusNode();

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
//          instaPostLeftData.add(InstaPostData(image, "@test${i}", ""));
          instaPostData.add(InstaPostData(image, "@test${i}", ""));
        } else {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
//          instaPostLeftData.add(InstaPostData(image, "@test${i}", ""));
          instaPostData.add(InstaPostData(image, "@test${i}", ""));
        }
      } else {
        if (i == 7) {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          image.add("assets/test/test${i + 2}.png");
//          instaPostRightData.add(InstaPostData(image, "@test${i}", ""));
          instaPostData.add(InstaPostData(image, "@test${i}", ""));
        } else {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
//          instaPostRightData.add(InstaPostData(image, "@test${i}", ""));
          instaPostData.add(InstaPostData(image, "@test${i}", ""));
        }
      }
    }
  }

  homeAppBar() => AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: White,
        title: upPanelMenuType != 2
            ? GestureDetector(
                onTap: () async {
                  print("카페 지역 선택");
                  setState(() {
                    cafeSelect = false;
                  });
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationSearch(
                          cafeLocation: cafeLocation,
                        ),
                      )).then((result) {
                    setState(() {
                      cafeLocation = result.toString();
                      cafeSelect = true;
                      _mainBloc.setStreet(cafeLocation);
                      print("aa : " + cafeLocation);
                    });
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      cafeLocation,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Black),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: mainColor,
                      size: 18,
                    )
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 167, 167, 167),
                      size: 14,
                    ),
                    whiteSpaceW(5),
                    Text(
                      userLocation,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Black),
                    ),
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
        actions: <Widget>[
          upPanelMenuType != 2
              ? whiteSpaceW(MediaQuery.of(context).size.width / 5)
              : GestureDetector(
                  onTap: () {
                    print("현위치로");
                    getLocation();
                  },
                  child: Center(
                    child: Text(
                      "현위치로",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: mainColor),
                    ),
                  ),
                ),
          upPanelMenuType == 2 ? whiteSpaceW(20) : Container()
        ],
      );

  searchOrTagList() => ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemBuilder: (context, idx) {
          print("iii : " +
              idx.toString() +
              ", " +
              searchTagList.length.toString());
          return idx == searchTagList.length - 1
              ? GestureDetector(
                  onTap: () {
                    print("rowtouch");
                    FocusScope.of(context).requestFocus(_searchNode);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              searchTagList.removeAt(idx);
                              if (searchTagList.length < 1) {
                                searchEnable = false;
                                tagOr = false;
                              }
                            });
                          },
                          child: Badge(
                            toAnimate: false,
                            badgeContent: Padding(
                              padding: EdgeInsets.all(0),
                              child: Icon(
                                Icons.clear,
                                size: 12,
                                color: Black,
                              ),
                            ),
                            child: Text(searchTagList[idx],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainColor,
                                )),
                            badgeColor: Colors.transparent,
                            elevation: 0.0,
                            position:
                                BadgePosition.topRight(top: -10, right: -10),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: TextFormField(
                          controller: _searchController,
                          focusNode: _searchNode,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              fontSize: 14,
                              color: Black,
                              fontWeight: FontWeight.bold),
                          onFieldSubmitted: (value) {
                            if (value == null || value == " " || value == "") {
                              _searchController.text = "";
                            } else {
                              setState(() {
                                addTagList(value);
                                autoTagList.clear();
                                autoTag = false;
                                _searchController.text = "";
                                FocusScope.of(context)
                                    .requestFocus(_searchNode);
                              });
                              lastTagMove();
                            }
                          },
                          onChanged: (value) {
//                          print("value : " + value);
                            if (value == null || value == "" || value == " ") {
                              setState(() {
                                autoTag = false;
                              });
                            } else {
                              setState(() {
                                autoTag = true;
                                setSearchEnable(value);
                                _mainBloc.setKeyword(value);
//                              getAutoTag();
                              });
                            }

                            if (value == null || value == " ") {
                              _searchController.text = "";
                            } else {
                              if (value.contains(" ")) {
                                if (addKeyWord == false) {
                                  setState(() {
                                    addTagList(value);
                                    _searchController.text = "";
                                    addKeyWord = true;
                                    autoTag = false;
                                    autoTagList.clear();
                                    FocusScope.of(context)
                                        .requestFocus(_searchNode);
                                  });
                                  lastTagMove();
                                }
                              }
                              if (value == "") {
                                addKeyWord = false;
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
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      searchTagList.removeAt(idx);
                      if (searchTagList.length < 1) {
                        searchEnable = false;
                        tagOr = false;
                      }
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Center(
                        child: Badge(
                          toAnimate: false,
                          badgeContent: Padding(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.clear,
                              size: 12,
                              color: Black,
                            ),
                          ),
                          child: Text(searchTagList[idx],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainColor,
                              )),
                          badgeColor: Colors.transparent,
                          elevation: 0.0,
                          position:
                              BadgePosition.topRight(top: -10, right: -10),
                        ),
                      )),
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
                      height: 40,
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
                                    focusNode: _searchNode,
                                    controller: _searchController,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      if (value == null ||
                                          value == " " ||
                                          value == "") {
                                        _searchController.text = "";
                                      } else {
                                        setState(() {
                                          addTagList(value);
                                          _searchController.text = "";
                                          tagOr = true;
                                          autoTag = false;
                                          autoTagList.clear();
                                          FocusScope.of(context)
                                              .requestFocus(_searchNode);
                                        });
                                        lastTagMove();
                                      }
                                    },
                                    onChanged: (value) {
                                      print("value51 : " + value);
                                      if (value == null ||
                                          value == "" ||
                                          value == " ") {
                                        setState(() {
                                          autoTag = false;
                                          setSearchEnable(value);
                                        });
                                      } else {
                                        print("check123");
                                        setState(() {
                                          setSearchEnable(value);
                                          autoTag = true;
                                          _mainBloc.setKeyword(value);
//                                          getAutoTag();
                                        });
                                      }

                                      if (value == null ||
                                          value == " " ||
                                          value == "") {
                                        _searchController.text = "";
                                      } else {
                                        if (value.contains(" ")) {
                                          print("check");
                                          if (addKeyWord == false) {
                                            setState(() {
                                              searchTagList
                                                  .add(_searchController.text);
                                              tagOr = true;
                                              addKeyWord = true;
                                              autoTag = false;
                                              _searchController.text = "";
                                              autoTagList.clear();
                                              FocusScope.of(context)
                                                  .requestFocus(_searchNode);
                                            });
                                            lastTagMove();
                                          }
                                        } else {}
                                      }
                                      if (value == "") {
                                        addKeyWord = false;
                                      }
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
                            searchTagList.clear();
                            autoTagList.clear();
                            tagOr = false;
                            addKeyWord = false;
                            directSearching = false;
                            _searchController.text = "";
                            searchEnable = false;
                            autoTag = false;
                          });
                        },
                        child: Container(
                          color: White,
                          child: Text(
                            "취소",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
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

  tagList(type) => ListView.builder(
        itemCount: tagListItem.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                if (type == 0) {
                  setState(() {
                    bool autoing = false;
                    if (clickNum == position) {
                      clickNum = null;
                      keyword = "";
                      keywordSearching = false;
                      if (autoing) {
                        autoTag = true;
                        autoing = false;
                      }
                      // 선택해제
                    } else {
                      clickNum = position;
                      keyword = tagListItem[position];
                      keywordSearching = true;
                      if (autoTag) {
                        autoTag = false;
                        autoing = true;
                      }
                      // 선택
                    }
                  });
                } else if (type == 1) {
                  setState(() {
                    addTagList(tagListItem[position]);
                    tagOr = true;
                    autoTag = false;
                    _searchController.text = "";
                    autoTagList.clear();
                  });
                  lastTagMove();
                }
                print("태그 클릭 : " + tagListItem[position]);
              },
              child: Container(
                width: 60,
                height: 30,
                decoration:
                    clickNum == position ? tagClickDecoration : tagDecoration,
                child: Center(
                  child: Text(
                    "#${tagListItem[position]}",
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
                    print("check");
                    if (menuType == 2) {
                      permissionCheck().then((pass) {
                        if (pass == true) {
                          if (userLocation == "") {
                            getLocation();
                          }

                          setState(() {
                            upPanelMenuType = menuType;
                          });
                        } else {
                          CafeLogSnackBarWithOk(
                              context: context,
                              msg: "위치 권한을 동의해주세요.",
                              okMsg: "확인");
                        }
                      });
                    } else {
                      setState(() {
                        upPanelMenuType = menuType;
                      });
                    }
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
//        border: Border.all(color: upPanelColor, width: 0.1),
        backdropEnabled: false,
        parallaxEnabled: false,
        boxShadow: [
          BoxShadow(color: Color.fromARGB(255, 219, 219, 219), blurRadius: 7)
        ],
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
            ? upPanelMenuType == 1
                ? cafeSelect
                    ? PopularityCafe(
                        cafeLocation: cafeLocation,
                      )
                    : Container()
                : upPanelMenuType == 2 ? MyAround() : body()
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
                  "검색하신 키워드에\n기록이 없습니다.",
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
        padding: EdgeInsets.only(top: 10, bottom: 150, left: 15, right: 15),
        child: Container(
            width: MediaQuery.of(context).size.width,
//          height: MediaQuery.of(context).size.height,
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: instaPostData.length,
              itemBuilder: (context, idx) => GestureDetector(
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
                          instaPostData[idx].img[0],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Text(
                        instaPostData[idx].instaName,
                        style: instaPostDataNameText,
                      ),
                      bottom: 15,
                      left: 5,
                    ),
                    instaPostData[idx].img.length == 2
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
              ),
              staggeredTileBuilder: (idx) => StaggeredTile.fit(1),
              crossAxisSpacing: 15.0,
            )),
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
                child: tagList(0),
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
          if (searchEnable) {
            // 검색한 결과를 메인으로 리턴
            setState(() {
              for (int i = 0; i < searchTagList.length; i++) {
                prefSetValue(searchTagList[i]);
              }
              _searchController.text = "";
              autoTagList.clear();
              searchTagList.clear();
              tagOr = false;
              addKeyWord = false;
              directSearching = false;
              searchEnable = false;
            });
          }
        },
        child: Container(
          width: 123,
          height: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: searchEnable == true
                  ? mainColor
                  : Color.fromARGB(255, 167, 167, 167),
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
                        child: tagList(1),
                      ),
                    ),
                    autoTag == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              searchList.length == 0
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, top: 20),
                                      child: Text(
                                        "최근 검색 키워드",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, right: 20, top: 20),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "최근 검색 키워드",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                searchList.clear();
                                                prefSet();
                                              });
                                            },
                                            child: Text(
                                              "전체삭제",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              (searchList.length == 0)
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Center(
                                        child: Text(
                                          "최근 검색한 키워드가 없습니다.",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 158, 154, 154)),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: keyBoardOn == false
                                          ? MediaQuery.of(context).size.height /
                                              2
                                          : MediaQuery.of(context).size.height /
                                              5.5,
                                      child: ListView.builder(
                                        itemBuilder: (context, idx) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: 15,
                                                right: 35,
                                                top: 10,
                                                bottom: 10),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      searchList[idx],
                                                      style: TextStyle(
                                                          color: Black,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      searchList.removeAt(idx);
                                                      prefSet();
                                                    },
                                                    child: Text(
                                                      "X",
                                                      style: TextStyle(
                                                          color: Black,
                                                          fontSize: 14),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        shrinkWrap: true,
                                        itemCount: searchList.length,
                                      ),
                                    ),
                            ],
                          )
                        : StreamBuilder(
                            stream: _mainBloc.getAutoTag(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print("error");
                              }
                              if (snapshot.hasData) {
                                if (snapshot.data != null &&
                                    snapshot.data.isNotEmpty) {
                                  List<dynamic> valueList = json
                                      .decode(snapshot.data)['data']['tags'];
                                  autoTagList.clear();

                                  for (int i = 0; i < valueList.length; i++) {
                                    autoTagList.add(AutoTag(
                                        id: valueList[i]['id'],
                                        name: valueList[i]['name']));
                                  }

                                  if (autoTagList != null &&
                                      autoTagList.isNotEmpty &&
                                      autoTagList.length >= 0) {
                                    return ListView.builder(
                                      itemBuilder: (context, idx) {
                                        if (idx < autoTagList.length &&
                                            idx >= 0) {
//                                  print("length : " + autoTagList.length.toString());

                                          bool firstStart = autoTagList[idx]
                                                      .name
                                                      .indexOf(_searchController
                                                          .text) ==
                                                  0
                                              ? true
                                              : false;
                                          bool twoWord = true;
                                          String firstWord,
                                              middleWord,
                                              finishWord;

                                          if (autoTagList != null &&
                                              autoTagList.isNotEmpty &&
                                              _searchController.text.length >
                                                  0 &&
                                              autoTagList[idx].name.length !=
                                                  0) {
                                            if (firstStart) {
                                              firstWord = autoTagList[idx]
                                                  .name
                                                  .substring(
                                                      autoTagList[idx]
                                                          .name
                                                          .indexOf(
                                                              _searchController
                                                                  .text),
                                                      autoTagList[idx]
                                                              .name
                                                              .indexOf(
                                                                  _searchController
                                                                      .text) +
                                                          _searchController
                                                              .text.length);
                                              middleWord = autoTagList[idx]
                                                  .name
                                                  .substring(autoTagList[idx]
                                                          .name
                                                          .indexOf(
                                                              _searchController
                                                                  .text) +
                                                      1);
                                            } else {
                                              firstWord = autoTagList[idx]
                                                  .name
                                                  .substring(
                                                      0,
                                                      autoTagList[idx]
                                                          .name
                                                          .indexOf(
                                                              _searchController
                                                                  .text));
                                              middleWord = autoTagList[idx]
                                                  .name
                                                  .substring(
                                                      autoTagList[idx]
                                                          .name
                                                          .indexOf(
                                                              _searchController
                                                                  .text),
                                                      autoTagList[idx]
                                                              .name
                                                              .indexOf(
                                                                  _searchController
                                                                      .text) +
                                                          _searchController
                                                              .text.length);
                                              finishWord = autoTagList[idx]
                                                  .name
                                                  .substring(autoTagList[idx]
                                                          .name
                                                          .indexOf(
                                                              _searchController
                                                                  .text) +
                                                      1);
                                              twoWord = false;
                                            }
                                          }
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 20),
                                            child: Container(
                                              color: White,
                                              child: GestureDetector(
                                                onTap: () {
                                                  print(
                                                      "clickTag : ${autoTagList[idx].name}");
                                                  setState(() {
                                                    addTagList(
                                                        autoTagList[idx].name);
                                                    tagOr = true;
                                                    autoTag = false;
                                                    _searchController.text = "";
                                                    autoTagList.clear();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            _searchNode);
                                                  });
                                                  lastTagMove();
                                                },
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: "#",
                                                      style: TextStyle(
                                                          color: Black,
                                                          fontSize: 14),
                                                      children: <TextSpan>[
                                                        twoWord == true
                                                            ? TextSpan(
                                                                text: firstWord,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        Black))
                                                            : TextSpan(
                                                                text: firstWord,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            135,
                                                                            135,
                                                                            135))),
                                                        twoWord == true
                                                            ? TextSpan(
                                                                text:
                                                                    middleWord,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            135,
                                                                            135,
                                                                            135)))
                                                            : TextSpan(
                                                                text:
                                                                    middleWord,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        Black)),
                                                        twoWord == false
                                                            ? TextSpan(
                                                                text:
                                                                    finishWord,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            135,
                                                                            135,
                                                                            135)))
                                                            : TextSpan()
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                      shrinkWrap: true,
                                      itemCount: 5,
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              }
                              return Container();
                            },
                          )
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
    ErrorWidget.builder = (error) {
      return customErrorWidget(context, error);
    };
    return WillPopScope(
      onWillPop: () {
        if (directSearching == true) {
          setState(() {
            _searchController.text = "";
            autoTagList.clear();
            searchTagList.clear();
            tagOr = false;
            addKeyWord = false;
            directSearching = false;
            searchEnable = false;
            autoTag = false;
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
