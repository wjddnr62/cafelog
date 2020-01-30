import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/cafeListData.dart';
import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Model/popularMenu.dart';
import 'package:cafelog/Model/popularityCafeData.dart';
import 'package:cafelog/Model/streetsData.dart';
import 'package:cafelog/Screens/Home/instaDetail.dart';
import 'package:cafelog/Screens/PopularityCafe/morePicture.dart';
import 'package:cafelog/Screens/PopularityCafe/naverCafeInfo.dart';
import 'package:cafelog/Util/numberFormat.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/Widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../colors.dart';
import 'cafeLocation.dart';

class CafeDetail extends StatefulWidget {
  String cafeName;
  String identify;
  String phone;
  String imgUrl;
  String naverUrl;
  String distance;
  String subName;
  String address;
  LatLng latLng;
  String convenien;
  String menu;
  String openTime;

  CafeDetail(
      {Key key,
      this.cafeName,
      this.identify,
      this.phone,
      this.imgUrl,
      this.naverUrl,
      this.distance,
      this.subName,
      this.address,
      this.latLng,
      this.convenien,
      this.menu,
      this.openTime})
      : super(key: key);

  @override
  _CafeDetail createState() => _CafeDetail();
}

class _CafeDetail extends State<CafeDetail> {
  bool mainImageCheck = true;

  double topHeight = 0.0;

  bool gpsOn = false;

  String title = "하이데어";
  String distance = "1.7km";
  bool open = false;

  String cafeDes = "커피보다 스콘이 맛있는 카페";
  String cafeAddress = "서울특별시 중구 충무로9길 0223 1층 ACAFE";

  int personNumAll = 52100;
  int personWeek = 500;

  List<String> serviceTag = List();

  bool menuExist = false;

  List<PopularMenu> popularMenuList = List();

  bool cafeUserImage = true;

  int allRecord = 0;

//  List<InstaPostData> instaPostLeftData = [];
//  List<InstaPostData> instaPostRightData = [];

  bool loading = false;

  ScrollController _scrollController = ScrollController(keepScrollOffset: true);

//  int defaultLeftLength = 10;
//  int defaultRightLength = 10;
  List<CafeListData> _cafeList = [];
  int defaultLength = 10;
  int defaultOffSet = 0;

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

  SharedPreferences sharedPreferences;
  String accessToken;

  sharedInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.getString("accessToken");
    checkFavorite();
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

  bool firstData = false;
  double offset = 0.0;

  checkEndList() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (defaultLength != _cafeList.length) {
          if ((defaultLength + 10) > _cafeList.length) {
            defaultLength = _cafeList.length;
          } else {
            defaultLength += 10;
          }
        }
        loading = true;
        firstData = false;
      });
      setState(() {});
      print("bottom");
    }
  }

  PopularityCafeData detailStreet;
  bool getData = false;
  bool favoriteCheck = false;

  checkFavorite() async {
    mainBloc.setFavoriteId(accessToken);
    mainBloc.setFavoriteName(widget.cafeName);

    print("dataCheck : ${accessToken}, ${widget.cafeName}");

    mainBloc.getFavorite().then((value) {
      print("getFavoriteValue : ${value}");
      if (json.decode(value)['data'].length != 0) {
        setState(() {
          favoriteCheck = true;
        });
      }
    });
  }

  @override
  void initState() {
    _scrollController.addListener(checkEndList);
    super.initState();

    sharedInit();

    gpsCheck();

    List<String> tagSplit;
    if (widget.convenien.isNotEmpty && widget.convenien != "") {
      tagSplit = widget.convenien.split(", ");

      if (tagSplit.length > 0) {
        for (int i = 0; i < tagSplit.length; i++) {
          serviceTag.add(tagSplit[i]);
        }
      } else {
        serviceTag.add(widget.convenien);
      }
    }

//    serviceTag..add("주차가능")..add("반려견출입가능")..add("노키즈존")..add("공기청정기");

    popularMenuList
      ..add(PopularMenu(menuName: "아메리카노", eatPerson: 675))
      ..add(PopularMenu(menuName: "브런치세트", eatPerson: 1021))
      ..add(PopularMenu(menuName: "비포선라이즈파스타", eatPerson: 786))
      ..add(PopularMenu(menuName: "베이컨파스타", eatPerson: 111))
      ..add(PopularMenu(menuName: "아메리칸브렉퍼스트", eatPerson: 213));

    print("cafeName : ${widget.cafeName}");

    mainBloc.setRecodeTag(widget.cafeName);
    mainBloc.getCafeRecodeCount().then((value) {
      setState(() {
        allRecord = json.decode(value)['data'];
      });
    });

    mainBloc.setDetailName(widget.cafeName);
    mainBloc.getCafeDetailPerson().then((value) {
//      print('value : ${value}');
//      detailStreet = json.decode(value)['data'];

//      print("data : ${json.decode(value)['data']}");

      detailStreet = PopularityCafeData(
          userNum: json.decode(value)['data']['user_num'],
          recentNum: json.decode(value)['data']['recent_num']);
      setState(() {
        getData = true;
      });
    });
  }

  favoriteFab() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          if (favoriteCheck == false) {
            mainBloc.setFavoriteId(accessToken);
            mainBloc.setFavoriteName(widget.cafeName);
            mainBloc.setFavoriteIdentify(widget.identify);

            mainBloc.insertFavorite().then((value) {
              CafeLogSnackBarWithOk(context: context, okMsg: "확인", msg: "\"${widget.cafeName}\"가 즐겨찾기에 추가되었습니다.");
            });
            setState(() {
              favoriteCheck = true;
            });
          } else {
            mainBloc.setFavoriteIdentify(widget.identify);

            mainBloc.deleteFavorite().then((value) {
              CafeLogSnackBarWithOk(context: context, okMsg: "확인", msg: "\"${widget.cafeName}\"가 즐겨찾기에 제거되었습니다.");
            });
            setState(() {
              favoriteCheck = false;
            });
          }
        },
        child: Icon(
          favoriteCheck ? Icons.star: Icons.star_border,
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

  mainListGrid() {
    if (!firstData) {
      print("defaultOffSet : ${defaultOffSet}");
      mainBloc.setLimit(defaultOffSet);
      mainBloc.setTag(widget.cafeName);
      mainBloc.setType("1");

      mainBloc.getMainList().then((value) async {
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
          CafeLogSnackBarWithOk(context: context, okMsg: "확인", msg: "더 이상 표시할 카페 기록이 없습니다.");
        }
      }).catchError((error) {
        print("error : ${error}");
      });
    }
    return (_cafeList.length == 0 && firstData == false)
        ? Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 5),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: StaggeredGridView.countBuilder(
//            controller: _scrollController,
              physics: NeverScrollableScrollPhysics(),
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
                              imageUrl: _cafeList[idx].pic,
//                              placeholder: (context, url) =>
//                                  CircularProgressIndicator(
//                                valueColor:
//                                    AlwaysStoppedAnimation<Color>(mainColor),
//                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/defaultImage.png",
                                fit: BoxFit.fill,
                              ),
                            )
//                        FadeInImage(image: NetworkImage(_cafeList[idx].pic), fit: BoxFit.fill, placeholder: AssetImage("assets/defaultImage.png"), ),
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
                  ],
                ),
              ),
              staggeredTileBuilder: (idx) => StaggeredTile.fit(1),
              crossAxisSpacing: 10.0,
            ));
  }

//  instaCafePost() => Padding(
//        padding: EdgeInsets.only(left: 10, right: 10),
//        child: Container(
//          width: MediaQuery.of(context).size.width,
//          child: StaggeredGridView.countBuilder(
//            crossAxisCount: 2,
//            physics: NeverScrollableScrollPhysics(),
//            shrinkWrap: true,
//            itemCount: defaultLength,
//            itemBuilder: (context, idx) => GestureDetector(
//              onTap: () {
//                print("postData");
//              },
//              child: Stack(
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.only(bottom: 10),
//                    child: Container(
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(10)),
//                      child: Image.asset(
//                        instaPostData[idx].img[0],
//                        fit: BoxFit.fill,
//                      ),
//                    ),
//                  ),
//                  Positioned(
//                    child: Text(
//                      instaPostData[idx].instaName,
//                      style: TextStyle(
//                                    fontSize: 12,
//                                    fontWeight: FontWeight.bold,
//                                    color: White,
//                                    shadows: [
//                                      Shadow(color: Black, blurRadius: 5)
//                                    ]),
//                    ),
//                    bottom: 15,
//                    left: 5,
//                  ),
//                  instaPostData[idx].img.length == 2
//                      ? Positioned(
//                    child: Icon(
//                      Icons.photo_library,
//                      color: White,
//                      size: 14,
//                    ),
//                    right: 5,
//                    bottom: 15,
//                  )
//                      : Container()
//                ],
//              ),
//            ),
//            staggeredTileBuilder: (idx) => StaggeredTile.fit(1),
//            crossAxisSpacing: 15.0,
//          )
//        ),
//      );

  mainImage() => mainImageCheck
      ? Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20 + topHeight),
          // CachedNetworkImage 로 변경할 것
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.imgUrl,
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
                                                widget.cafeName,
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
                                                        widget.distance,
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
                                    widget.subName,
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
                                            widget.address,
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
                                                setState(() {
                                                  loading = true;
                                                });
                                                permissionCheck().then((pass) {
                                                  if (pass == true) {
                                                    print("pass");
                                                    //37.468443, 126.887603
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          CafeLocation(
                                                        latLng: widget.latLng,
                                                        cafeAddress:
                                                            widget.address,
                                                      ),
                                                    ));
                                                    setState(() {
                                                      loading = false;
                                                    });
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
                                                getData
                                                    ? "${numberFormat.format(detailStreet.userNum)} 명"
                                                    : "0 명",
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
                                                getData
                                                    ? "최근 1개월 ${numberFormat.format(detailStreet.recentNum)} 명"
                                                    : "최근 1개월 0 명",
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
                                                        widget.phone,
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
                                                    List<String> phoneSplit =
                                                        widget.phone.split("-");
                                                    String phone;
                                                    for (int i = 0;
                                                        i < phoneSplit.length;
                                                        i++) {
                                                      phone += phoneSplit[i];
                                                    }
                                                    launch("tel:${phone}");
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
                                      child: serviceTag.length == 0
                                          ? Center(
                                              child: Text(
                                                "아직 편의시설 정보가 부족합니다.",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 122, 122, 122),
                                                    fontSize: 12),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : GridView.count(
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
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                            ),
                                    ),
                                  ),
                                  whiteSpaceH(20),
//                                  Center(
//                                    child: GestureDetector(
//                                      onTap: () {
//                                        Navigator.of(context)
//                                            .pushNamed('/StoreDetail');
//                                      },
//                                      child: Text(
//                                        "정보 더보기",
//                                        style: TextStyle(
//                                            fontSize: 12,
//                                            fontWeight: FontWeight.w600,
//                                            color: mainColor),
//                                      ),
//                                    ),
//                                  ),
//                                  whiteSpaceH(60),
                                  Center(
                                    child: Text(
                                      "인기키워드",
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
//                                                  Expanded(
//                                                    flex: 2,
//                                                    child: Container(
//                                                        width: 60,
//                                                        child: Text(
//                                                          "먹어본 사람",
//                                                          style: TextStyle(
//                                                              color: Color
//                                                                  .fromARGB(
//                                                                      255,
//                                                                      167,
//                                                                      167,
//                                                                      167),
//                                                              fontSize: 12,
//                                                              fontWeight:
//                                                                  FontWeight
//                                                                      .w600),
//                                                        )),
//                                                  ),
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
                                            "키워드 정보가 부족합니다.",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 122, 122, 122)),
                                          ),
                                        ),
                                  menuExist ? whiteSpaceH(60) : whiteSpaceH(90),
                                  menuExist
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed("/CafeMenu");
                                          },
                                          child: Center(
                                            child: Text(
                                              "메뉴 보기",
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  menuExist ? whiteSpaceH(60) : Container(),
                                  GestureDetector(
                                    onTap: () {
//                                      Navigator.of(context)
//                                          .pushNamed('/NaverCafeInfo');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NaverCafeInfo(
                                              url: widget.naverUrl,
                                            ),
                                          ));
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
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MorePicture(
                                                            cafeName:
                                                                widget.cafeName,
                                                          ),
                                                        ));
                                                  },
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
                                            ),
                                            whiteSpaceH(10),
                                            mainListGrid(),
                                            whiteSpaceH(40),
//                                            Center(
//                                              child: GestureDetector(
//                                                onTap: () {
//                                                  Navigator.of(context).pushNamed("/MorePicture");
//                                                },
//                                                child: Text(
//                                                  "사진 더보기",
//                                                  style: TextStyle(
//                                                      fontSize: 14,
//                                                      color: mainColor,
//                                                      fontWeight:
//                                                          FontWeight.w600),
//                                                ),
//                                              ),
//                                            )
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
            controller: _scrollController,
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
          loading == true
              ? Positioned.fill(
                  child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ))
              : Container()
        ],
      ),
    );
  }
}
