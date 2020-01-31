import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/autoTagData.dart';
import 'package:cafelog/Model/cafeListData.dart';
import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Screens/CafeLocationSearch/locationSearch.dart';
import 'package:cafelog/Screens/Home/favorite.dart';
import 'package:cafelog/Screens/Home/instaDetail.dart';
import 'package:cafelog/Screens/Home/settings.dart';
import 'package:cafelog/Screens/Login/loginMain.dart';
import 'package:cafelog/Screens/MyAround/myAround.dart';
import 'package:cafelog/Screens/MyAround/myAroundMap.dart';
import 'package:cafelog/Screens/PopularityCafe/popularityCafe.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/Widgets/snackbar.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  List<CafeListData> _cafeList = [];
  int defaultLength = 10;
  ScrollController _mainScroll = ScrollController(keepScrollOffset: true);
  int defaultOffSet = 0;

  SharedPreferences sharedPreferences;
  String accessToken;

  sharedInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.getString("accessToken");
  }

  checkEndList() {
    if (_mainScroll.offset >= _mainScroll.position.maxScrollExtent &&
        !_mainScroll.position.outOfRange) {
      setState(() {
        loading = true;
        firstData = false;
//        mainListGrid();
      });
//      setState(() {});
//      });
      print("bottom");
    }
  }

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

  List<String> tagListItemSearch = [
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
  final threePanelHover =
      TextStyle(fontSize: 14.0, color: White, fontWeight: FontWeight.bold);
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

  bool mapSelect = false;

  ScrollController _autoTagScroll = ScrollController();

  bool loading = false;

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
    if (searchTagList.length > 0 && _scrollController.hasClients) {
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
    print("typeCheck : ${upPanelMenuType}, ${searchTagList.length}");
    if (upPanelMenuType == 0 && searchTagList.length > 0) {
      print("addTagList : ${value}");
      CafeLogSnackBarWithOk(
          msg: "홈에서 태그검색은 한 가지만 가능합니다.", context: context, okMsg: "확인");
    } else {
      print("addValue : ${value}");
      searchTagList.add(value);
    }

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
  LatLng latLng;
  var address;
  String userLocation = "";

  getLocation(type, getLatLng) async {
    if (type == 0) {
      try {
        currentLocation = await location.getLocation();
        final coordinates = new Coordinates(
            currentLocation.latitude, currentLocation.longitude);
        latLng = LatLng(currentLocation.latitude, currentLocation.longitude);
        List<Address> addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        for (int i = 0; i < addresses.length; i++) {
          print("address : ${addresses[i].addressLine}");
        }
        address = addresses.first;
        print("${address.featureName}, ${address.addressLine}");
        List<String> lines = address.addressLine.toString().split(" ");
        setState(() {
          userLocation = "";
          for (int i = 0; i < lines.length; i++) {
            print("lines : ${lines[i]}");
            /*if (lines[i].contains("구")) {
              userLocation += lines[i];
            } else if (lines[i].contains("로")) {
              userLocation += " " + lines[i];
            }*/
            if (i > 1) {
              if (lines[i].contains("구")) {
                mainBloc.setAddr(lines[i]);
              } else if (lines[i].contains("동")) {
                print("setAddr2 : ${lines[i]}");
                mainBloc.setAddr2(lines[i]);
              }
              if (lines[i].contains("구") || lines[i].contains("동"))
                userLocation += lines[i] + " ";
            }
          }
        });
      } on Exception catch (e) {
        getLocation(0, "");
      }
    } else {
      try {
        final coordinates =
            new Coordinates(getLatLng.latitude, getLatLng.longitude);
        latLng = LatLng(getLatLng.latitude, getLatLng.longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        address = addresses.first;
        print("${address.featureName}, ${address.addressLine}");
        List<String> lines = address.addressLine.toString().split(" ");
        setState(() {
          userLocation = "";
          for (int i = 0; i < lines.length; i++) {
            print("lines : ${lines[i]}");
//            if (lines[i].contains("구")) {
//              userLocation += lines[i];
//            } else if (lines[i].contains("로")) {
//              userLocation += " " + lines[i];
//            }
            if (i > 1) {
              if (lines[i].contains("구")) {
                mainBloc.setAddr(lines[i]);
              } else if (lines[i].contains("동")) {
                print("setAddr2 : ${lines[i]}");
                mainBloc.setAddr2(lines[i]);
              }
              if (lines[i].contains("구") || lines[i].contains("동"))
                userLocation += lines[i] + " ";
            }
          }
        });
      } on Exception catch (e) {
        getLocation(1, getLatLng);
      }
    }
  }

  bool firstData = false;

  mainListGrid() {
    if (!firstData) {
      print("defaultOffSet : ${defaultOffSet}");
      _mainBloc.setLimit(defaultOffSet);

      _mainBloc.getMainList().then((value) async {
        if (json.decode(value)['result'] != 0 &&
            (json.decode(value)['data'] != null &&
                json.decode(value)['data'] != "" && json.decode(value)['data'].length != 0)) {
          if (!firstData) {
            defaultOffSet += 1;
            print('value : ${json.decode(value)['data']}');
            List<dynamic> valueList = await json.decode(value)['data'];
            print(valueList.length);
            if (valueList.length != 0) {
              for (int i = 0; i < valueList.length; i++) {
                _cafeList.add(CafeListData(
                    url: valueList[i]['url'],
                    nickname: valueList[i]['nickname'],
                    pic: valueList[i]['pic'],
                    date: valueList[i]['date'],
                    like: valueList[i]['like'],
                    search_tag: valueList[i]['search_tag']));
              }
            }
            firstData = true;
            loading = false;
          }
          setState(() {});
        } else {
          setState(() {
            firstData = true;
            loading = false;
          });
          CafeLogSnackBarWithOk(
              context: context, okMsg: "확인", msg: "더 이상 표시할 카페 기록이 없습니다.");
        }
      }).catchError((error) {
        print("error : ${error}");
      });
    }
    if (keywordSearching) {
      print("lenlen : " + _cafeList.length.toString());
      if (!firstData) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 5),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            ),
          ),
        );
      } else if (_cafeList.length == 0 && firstData == true) {
        return keywordSearch(keyword);
      } else {
        return firstData == false
            ? Padding(
                padding: EdgeInsets.only(bottom: 150, left: 35, top: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
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
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 150, left: 15, right: 15),
                child: StaggeredGridView.countBuilder(
                  controller: _mainScroll,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  itemCount: _cafeList.length,
                  itemBuilder: (context, idx) => GestureDetector(
                    onTap: () {
                      print("Name : ${_cafeList[idx].search_tag}");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstaDetail(
                              name: _cafeList[idx].search_tag,
                              instaUrl: _cafeList[idx].url,
                              offset: _mainScroll.offset,
                            ),
                          )).then((result) {
                        _mainScroll.animateTo(result,
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
                              child: Image.network(
                                _cafeList[idx].pic,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: Text(
                            "@" + _cafeList[idx].nickname,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: White,
                                shadows: [Shadow(color: Black, blurRadius: 5)]),
                          ),
                          bottom: 20,
                          left: 15,
                        ),
//                      instaPostData[idx].img.length == 2
//                          ? Positioned(
//                              child: Icon(
//                                Icons.photo_library,
//                                color: White,
//                                size: 14,
//                              ),
//                              right: 5,
//                              bottom: 15,
//                            )
//                          : Container()
                      ],
                    ),
                  ),
                  staggeredTileBuilder: (idx) => StaggeredTile.fit(1),
                  crossAxisSpacing: 10.0,
                ));
      }
    } else {
      return (_cafeList.length == 0 && firstData == false)
          ? Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ),
            )
          : (_cafeList.length == 0 && firstData == true)
              ? keywordSearch(keyword)
              : Stack(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 150, left: 15, right: 15),
                        child: StaggeredGridView.countBuilder(
                          controller: _mainScroll,
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          itemCount: _cafeList.length,
                          itemBuilder: (context, idx) => GestureDetector(
                            onTap: () {
                              print("Name : ${_cafeList[idx].search_tag}");

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InstaDetail(
                                      name: _cafeList[idx].search_tag,
                                      instaUrl: _cafeList[idx].url,
                                      offset: _mainScroll.offset,
                                      type: 0,
                                    ),
                                  )).then((result) {
                                _mainScroll.animateTo(result,
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
                                          imageUrl: _cafeList[idx].pic,
//                              placeholder: (context, url) =>
//                                  CircularProgressIndicator(
//                                    valueColor:
//                                    AlwaysStoppedAnimation<Color>(mainColor),
//                                  ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/defaultImage.png",
                                            fit: BoxFit.fill,
                                          ),
                                        )
//                            Image.network(
//                              _cafeList[idx].pic,
//                              fit: BoxFit.fill,
//                            ),
                                        ),
                                  ),
                                ),
                                Positioned(
                                  child: Text(
                                    "@" + _cafeList[idx].nickname,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: White,
                                        shadows: [
                                          Shadow(color: Black, blurRadius: 5)
                                        ]),
                                  ),
                                  bottom: 20,
                                  left: 15,
                                ),
//                      instaPostData[idx].img.length == 2
//                          ? Positioned(
//                              child: Icon(
//                                Icons.photo_library,
//                                color: White,
//                                size: 14,
//                              ),
//                              right: 5,
//                              bottom: 15,
//                            )
//                          : Container()
                              ],
                            ),
                          ),
                          staggeredTileBuilder: (idx) => StaggeredTile.fit(1),
                          crossAxisSpacing: 10.0,
                        )),
                    loading
                        ? Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 5),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(mainColor),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainScroll.addListener(checkEndList);
    super.initState();

    sharedInit();

    getLocation(0, "");
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

//    for (int i = 0; i < 10; i++) {
//      List<String> image = List();
//      if (i >= 0 && i < 5) {
//        if (i == 2) {
//          image.clear();
//          image.add("assets/test/test${i + 1}.png");
//          image.add("assets/test/test${i + 2}.png");
////          instaPostLeftData.add(InstaPostData(image, "@test${i}", ""));
//          instaPostData.add(InstaPostData(image, "@test${i}", ""));
//        } else {
//          image.clear();
//          image.add("assets/test/test${i + 1}.png");
////          instaPostLeftData.add(InstaPostData(image, "@test${i}", ""));
//          instaPostData.add(InstaPostData(image, "@test${i}", ""));
//        }
//      } else {
//        if (i == 7) {
//          image.clear();
//          image.add("assets/test/test${i + 1}.png");
//          image.add("assets/test/test${i + 2}.png");
////          instaPostRightData.add(InstaPostData(image, "@test${i}", ""));
//          instaPostData.add(InstaPostData(image, "@test${i}", ""));
//        } else {
//          image.clear();
//          image.add("assets/test/test${i + 1}.png");
////          instaPostRightData.add(InstaPostData(image, "@test${i}", ""));
//          instaPostData.add(InstaPostData(image, "@test${i}", ""));
//        }
//      }
//    }
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
//                      _mainBloc.setStreet(cafeLocation);
                      if (cafeLocation == "전체카페") {
                        _mainBloc.setMainStreet("");
                        _cafeList.clear();
                        defaultOffSet = 0;
                        _mainBloc.setLimit(defaultOffSet);
                        firstData = false;
                        mainListGrid();
                      } else {
                        _mainBloc.setMainStreet(cafeLocation);
                        _cafeList.clear();
                        defaultOffSet = 0;
                        _mainBloc.setLimit(defaultOffSet);
                        firstData = false;
                        mainListGrid();
                      }
                      print("street : " + cafeLocation);
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
                onTap: () {
                  if (latLng != null) {
                    setState(() {
                      mapSelect = true;
                    });

                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => MyAroundMap(
                                  latLng: latLng,
                                )))
                        .then((value) {
                      setState(() {
                        mapSelect = false;
                      });
                      if (value != null) {
                        latLng = latLng;
                        getLocation(1, value);
                      }
                    });
                  } else {
                    CafeLogSnackBarWithOk(
                        msg: "위치 정보를 받아오는 중입니다. 현위치로 버튼 클릭 또는 잠시 후에 다시 시도해주세요.",
                        okMsg: "확인",
                        context: context);
                  }
                },
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
                          fontSize: 14,
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
            Timer(
                Duration(milliseconds: 1000),
                () => _autoTagScroll.animateTo(
                      _autoTagScroll.position.maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 100),
                    ));
          },
          icon: Image.asset("assets/search.png", color: Color.fromARGB(255, 122, 122, 122), width: 23, height: 23,),
        ),
        actions: <Widget>[
          upPanelMenuType != 2
              ? whiteSpaceW(MediaQuery.of(context).size.width / 5)
              : GestureDetector(
                  onTap: () {
                    print("현위치로");
                    getLocation(0, "");
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
                      upPanelMenuType != 0
                          ? Container(
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
                                  if (value == null ||
                                      value == " " ||
                                      value == "") {
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
                                  if (value == null ||
                                      value == "" ||
                                      value == " ") {
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
                                        color:
                                            Color.fromARGB(255, 167, 167, 167)),
                                    hintText: "키워드 추가",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 5)),
                              ),
                            )
                          : Container()
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
        titleSpacing: 0.0,
        title: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
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
                            padding: EdgeInsets.only(left: 6.5),
                            child: Image.asset("assets/search.png", color: Color.fromARGB(255, 122, 122, 122), width: 23, height: 23,),
                          ),
                          // 태그 or list 들어갈 부분
                          tagOr == false
                              ? Expanded(
                                  child: TextFormField(
                                    onTap: () {
                                      if (upPanelMenuType == 0 &&
                                          searchTagList.length > 0) {
                                        CafeLogSnackBarWithOk(
                                            msg: "홈에서 태그검색은 한 가지만 가능합니다.",
                                            context: context,
                                            okMsg: "확인");
                                      }
                                    },
                                    readOnly: (searchTagList.length > 0 &&
                                            upPanelMenuType == 0)
                                        ? true
                                        : false,
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
                                            top: 5, bottom: 10, left: 5)),
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
                          width: 40,
                          height: 20,
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
        itemCount: type == 0 ? tagListItem.length : tagListItemSearch.length,
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
                      searchTagList.clear();
                      _mainBloc.setTag(null);
                      _cafeList.clear();
                      defaultOffSet = 0;
                      firstData = false;
                      mainListGrid();
                      // 선택해제
                    } else {
                      clickNum = position;
                      keyword = tagListItem[position];
//                      keywordSearching = true;
                      if (autoTag) {
                        autoTag = false;
                        autoing = true;
                      }
                      searchTagList.clear();
                      searchTagList.add(tagListItem[position]);
                      String tag = "";
                      for (int i = 0; i < searchTagList.length; i++) {
                        if (searchTagList.length == 1) {
                          tag += searchTagList[i];
                        } else if (i == searchTagList.length) {
                          tag += searchTagList[i];
                        } else {
                          tag += searchTagList[i] + ",";
                        }
                      }
                      _mainBloc.setTag(tag);
                      _cafeList.clear();
                      defaultOffSet = 0;
                      firstData = false;
                      mainListGrid();
                      // 선택
                    }
                  });
                } else if (type == 1) {
//                  if (searchTagList.length > 0) {
                    CafeLogSnackBarWithOk(
                        msg: "홈에서 태그검색은 한 가지만 가능합니다.",
                        context: context,
                        okMsg: "확인");
//                  } else {
                    setState(() {
                      searchTagList.clear();
                      addTagList(tagListItemSearch[position]);
                      tagOr = true;
                      autoTag = false;
                      _searchController.text = "";
                      autoTagList.clear();
                    });
                    lastTagMove();
//                  }
                }
                print("태그 클릭 : " + tagListItemSearch[position]);
              },
              child: Container(
//                width: 60,
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 30,
                decoration: type == 0
                    ? clickNum == position ? tagClickDecoration : tagDecoration
                    : tagDecoration,
                child: Center(
                  child: Text(
                    type == 0
                        ? "#${tagListItem[position]}"
                        : "#${tagListItemSearch[position]}",
                    style: type == 0
                        ? clickNum == position
                            ? TextStyle(fontSize: 12, color: White)
                            : TextStyle(fontSize: 12, color: Black)
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
          child: GestureDetector(
            onTap: () {
              if (sharedPreferences.getString("accessToken") != "" &&
                  sharedPreferences.getString("accessToken") != null &&
                  sharedPreferences.getString("accessToken").isNotEmpty) {
                setState(() {
                  upPanelMenuType = menuType;
                });
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/LoginMain', (Route<dynamic> route) => false);
              }

//              Navigator.of(context).pushNamed("/MyCafeLog");
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: upPanelMenuType != menuType
                        ? Color.fromARGB(255, 247, 247, 247)
                        : mainColor,
                    borderRadius: BorderRadius.circular(19)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 25 / 2),
                        child: Text(
                          menuName,
                          style: upPanelMenuType != menuType
                              ? mainUpPanelText
                              : threePanelHover,
                        ),
                      ),
                    ),
                    whiteSpaceH(10)
                  ],
                ),
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
                    if (menuType == 2) {
                      permissionCheck().then((pass) {
                        if (pass == true) {
                          if (userLocation == "") {
                            getLocation(0, "");
                          }

                          setState(() {
                            _searchController.text = "";
                            autoTagList.clear();
                            searchTagList.clear();
                            tagOr = false;
                            addKeyWord = false;
                            directSearching = false;
                            searchEnable = false;
                            clickNum = null;
                            keyword = "";
                            keywordSearching = false;
                            _mainBloc.setTag(null);
                            _cafeList.clear();
                            defaultOffSet = 0;
                            firstData = false;
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
                        _searchController.text = "";
                        autoTagList.clear();
                        searchTagList.clear();
                        tagOr = false;
                        addKeyWord = false;
                        directSearching = false;
                        searchEnable = false;
                        clickNum = null;
                        keyword = "";
                        keywordSearching = false;
                        _mainBloc.setTag(null);
                        _cafeList.clear();
                        defaultOffSet = 0;
                        firstData = false;
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
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Container(
                          width: 0.2,
                          height: 20,
                          color: Color.fromARGB(255, 151, 151, 151),
                        ),
                      ),
                    ),
                    upPanelMenu(3, "즐겨찾기")
                  ],
                ),
              )
            ],
          ),
        ),
        body: upPanelMenuType == 3
            ? Favorite()
            : directSearching == false
                ? upPanelMenuType == 1
                    ? cafeSelect
                        ? PopularityCafe(
                            cafeLocation: cafeLocation,
                            tags: tag,
                          )
                        : Container()
                    : upPanelMenuType == 2
                        ? mapSelect
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(mainColor),
                                ),
                              )
                            : MyAround(
                                tag: tag2,
                              )
                        : body()
                : searchBody(),
      );

  menuBar(content) => GestureDetector(
        onTap: () {
          if (content == "인기") {
            if (filterButton == true) {
              setState(() {
                _mainBloc.setType("0");
                _cafeList.clear();
                defaultOffSet = 0;
                _mainBloc.setLimit(defaultOffSet);
                firstData = false;
                mainListGrid();
                filterButton = false;
              });
            }
          } else if (content == "최신") {
            if (filterButton == false) {
              setState(() {
                _mainBloc.setType("1");
                _cafeList.clear();
                defaultOffSet = 0;
                _mainBloc.setLimit(defaultOffSet);
                firstData = false;
                mainListGrid();
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
                  "검색하신 태그에\n기록이 없습니다.",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  body() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: Row(
                children: <Widget>[
                  menuBar("인기"),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
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
                ? _cafeList.length == 0
                    ? whiteSpaceH(MediaQuery.of(context).size.height / 4.5)
                    : SizedBox()
                : SizedBox(),
            keywordSearching == false
//                ? instaCafePost()
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 80,
                    child: mainListGrid(),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: _cafeList.length != 0
                        ? MediaQuery.of(context).size.height - 80
                        : MediaQuery.of(context).size.height / 2.5,
                    child: mainListGrid(),
                  ),
          ],
        ),
        physics: NeverScrollableScrollPhysics(),
      );

  bool searchCheck = false;
  String tag = "";
  String tag2 = "";

  search() => GestureDetector(
        onTap: () {
          print("검색하기");
          searchCheck = false;
          if (searchEnable) {
            // 검색한 결과를 메인으로 리턴
            if (upPanelMenuType == 0) {
              setState(() {
                if (!tagOr) {
                  addTagList(_searchController.text);
                }
                autoTagList.clear();
                autoTag = false;
                _searchController.text = "";
                _mainBloc.setInsertTag(searchTagList[0]);
                _mainBloc.setAutoTag();
                tagListItem.insert(0, searchTagList[0]);
                clickNum = 0;
                keyword = tagListItem[0];
//                keywordSearching = true;
                for (int i = 0; i < searchTagList.length; i++) {
                  prefSetValue(searchTagList[i]);
                }
                searchList = searchList.reversed.toList();
                String tag = "";
                for (int i = 0; i < searchTagList.length; i++) {
                  if (searchTagList.length == 1) {
                    tag += searchTagList[i];
                  } else if (i == searchTagList.length) {
                    tag += searchTagList[i];
                  } else {
                    tag += searchTagList[i] + ",";
                  }
                }
                _mainBloc.setTag(tag);
                _cafeList.clear();
                defaultOffSet = 0;
                firstData = false;
                mainListGrid();
                _searchController.text = "";
                autoTagList.clear();
                searchTagList.clear();
                tagOr = false;
                addKeyWord = false;
                directSearching = false;
                searchEnable = false;
              });
            } else if (upPanelMenuType == 1) {
              setState(() {
                if (!tagOr) {
                  addTagList(_searchController.text);
                }
                tag = "";
                for (int i = 0; i < searchTagList.length; i++) {
                  if (searchTagList.length == 1) {
                    tag += searchTagList[i];
                  } else if (i == searchTagList.length) {
                    tag += searchTagList[i];
                  } else {
                    tag += searchTagList[i] + ",";
                  }
                }
                for (int i = 0; i < searchTagList.length; i++) {
                  prefSetValue(searchTagList[i]);
                }
                searchList = searchList.reversed.toList();
                _searchController.text = "";
                autoTagList.clear();
                searchTagList.clear();
                tagOr = false;
                addKeyWord = false;
                directSearching = false;
                searchEnable = false;
              });
            } else if (upPanelMenuType == 2) {
              setState(() {
                if (!tagOr) {
                  addTagList(_searchController.text);
                }
                tag2 = "";
                for (int i = 0; i < searchTagList.length; i++) {
                  if (searchTagList.length == 1) {
                    tag2 += searchTagList[i];
                  } else if (i == searchTagList.length) {
                    tag2 += searchTagList[i];
                  } else {
                    tag2 += searchTagList[i] + ",";
                  }
                }
                for (int i = 0; i < searchTagList.length; i++) {
                  prefSetValue(searchTagList[i]);
                }
                searchList = searchList.reversed.toList();
                _searchController.text = "";
                autoTagList.clear();
                searchTagList.clear();
                tagOr = false;
                addKeyWord = false;
                directSearching = false;
                searchEnable = false;
              });
            }
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
                                            child: Container(
//                                              width: 100,
                                              height: 20,
                                              color: White,
                                              child: Text(
                                                "전체삭제",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: mainColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              whiteSpaceH(10),
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
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (upPanelMenuType ==
                                                                0 &&
                                                            searchTagList
                                                                    .length >
                                                                0) {
                                                          CafeLogSnackBarWithOk(
                                                              msg:
                                                                  "홈에서 태그검색은 한 가지만 가능합니다.",
                                                              context: context,
                                                              okMsg: "확인");
                                                        } else {
                                                          setState(() {
                                                            addTagList(
                                                                searchList[
                                                                    idx]);
                                                            tagOr = true;
                                                            autoTag = false;
                                                            _searchController
                                                                .text = "";
                                                            autoTagList.clear();
                                                          });
                                                          lastTagMove();
                                                        }
                                                      },
                                                      child: Text(
                                                        searchList[idx],
                                                        style: TextStyle(
                                                            color: Black,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        searchList
                                                            .removeAt(idx);
                                                        prefSet();
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 10,
                                                      height: 20,
                                                      color: White,
                                                      child: Text(
                                                        "X",
                                                        style: TextStyle(
                                                            color: Black,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        shrinkWrap: true,
                                        itemCount: searchList.length,
                                        controller: _autoTagScroll,
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
                                  List<dynamic> valueList =
                                      json.decode(snapshot.data)['data'];
                                  autoTagList.clear();

                                  for (int i = 0; i < valueList.length; i++) {
                                    autoTagList
                                        .add(AutoTag(tag: valueList[i]['tag']));
                                    print("tag : ${valueList[i]['tag']}");
                                  }

                                  if (autoTagList != null &&
                                      autoTagList.isNotEmpty &&
                                      autoTagList.length >= 0) {
                                    return ListView.builder(
                                      itemBuilder: (context, idx) {
                                        if (idx < autoTagList.length &&
                                            idx >= 0) {
//                                  print("length : " + autoTagList.length.toString());

                                          print(
                                              "firstStart : ${autoTagList[idx].tag.indexOf(_searchController.text)}");
                                          bool firstStart = autoTagList[idx]
                                                      .tag
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
                                              autoTagList[idx].tag.length !=
                                                  0) {
                                            if (firstStart) {
                                              firstWord = autoTagList[idx]
                                                  .tag
                                                  .substring(
                                                      autoTagList[idx]
                                                          .tag
                                                          .indexOf(
                                                              _searchController
                                                                  .text),
                                                      autoTagList[idx].tag.indexOf(
                                                              _searchController
                                                                  .text) +
                                                          _searchController
                                                              .text.length);
                                              print("firstWord : ${firstWord}");
                                              if (firstWord !=
                                                  autoTagList[idx].tag) {
                                                middleWord = autoTagList[idx]
                                                    .tag
                                                    .substring(autoTagList[idx]
                                                                    .tag
                                                                    .indexOf(
                                                                        _searchController
                                                                            .text) +
                                                                firstWord
                                                                    .length ==
                                                            1
                                                        ? 1
                                                        : firstWord.length >=
                                                                _searchController
                                                                    .text.length
                                                            ? _searchController
                                                                .text.length
                                                            : 2);
                                              }

                                              print(
                                                  "middleWord : ${middleWord}");
                                            } else {
                                              firstWord = autoTagList[idx]
                                                  .tag
                                                  .substring(
                                                      0,
                                                      autoTagList[idx]
                                                          .tag
                                                          .indexOf(
                                                              _searchController
                                                                  .text));
                                              print(
                                                  "firstWord2 : ${firstWord}");
                                              middleWord = autoTagList[idx]
                                                  .tag
                                                  .substring(
                                                      autoTagList[idx]
                                                          .tag
                                                          .indexOf(
                                                              _searchController
                                                                  .text),
                                                      autoTagList[idx].tag.indexOf(
                                                              _searchController
                                                                  .text) +
                                                          _searchController
                                                              .text.length);
                                              print(
                                                  "middleWord2 : ${middleWord}, ${autoTagList[idx].tag}, ${autoTagList[idx].tag.indexOf(_searchController.text)}, ${autoTagList[idx].tag.indexOf(_searchController.text)}, ${_searchController.text.length}");
                                              if (autoTagList[idx].tag.length <=
                                                      2 &&
                                                  middleWord.length >=
                                                      autoTagList[idx]
                                                          .tag
                                                          .substring(
                                                              1,
                                                              autoTagList[idx]
                                                                      .tag
                                                                      .length -
                                                                  1)
                                                          .length) {
                                                finishWord = autoTagList[idx]
                                                    .tag
                                                    .substring(autoTagList[idx]
                                                            .tag
                                                            .length -
                                                        1);
                                              } else {
                                                finishWord = autoTagList[idx]
                                                    .tag
                                                    .substring(autoTagList[idx]
                                                            .tag
                                                            .indexOf(
                                                                _searchController
                                                                    .text) +
                                                        _searchController
                                                            .text.length);
                                              }

                                              if (_searchController.text
                                                  .contains(finishWord)) {
                                                finishWord = "";
                                              }
                                              print(
                                                  "finishWord2 : ${finishWord}");
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
                                                      "clickTag : ${autoTagList[idx].tag}");
                                                  setState(() {
                                                    addTagList(
                                                        autoTagList[idx].tag);
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
                                                      text: "",
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
          return Future.value(true);
        }
        return null;
      },
      child: Scaffold(
        appBar: directSearching == false
            ? upPanelMenuType == 3
                ? AppBar(
                    backgroundColor: White,
                    elevation: 0.0,
                    centerTitle: true,
                    title: Text(
                      "즐겨찾기",
                      style: TextStyle(
                          color: Black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Setting(
                                    id: accessToken,
                                  )));
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Color.fromARGB(255, 167, 167, 167),
                        ),
                      )
                    ],
                  )
                : homeAppBar()
            : searchingAppBar(),
        backgroundColor: White,
        resizeToAvoidBottomInset: true,
        body: slidingUpPanelBody(),
      ),
    );
  }
}
