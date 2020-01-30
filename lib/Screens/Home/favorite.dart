import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/favoriteData.dart';
import 'package:cafelog/Model/naverData.dart';
import 'package:cafelog/Screens/PopularityCafe/cafeDetail.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/Widgets/snackbar.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {
  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  MainBloc _mainBloc = MainBloc();

  SharedPreferences sharedPreferences;
  String accessToken;

  sharedInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.getString("accessToken");

    getFavoriteData();
  }

  bool notData = false;
  bool dataGet = false;
  List<FavoriteData> favoriteData = List();
  List<FavoriteCafeData> favoriteCafeData = List();
  List<String> locationSet = List();


  bool deleteMode = false;
  List<String> selectIdentify = List();
  List<bool> select = List();

  getFavoriteData() {
    _mainBloc.setFavoriteId(accessToken);
    _mainBloc.setFavoriteName("");
    _mainBloc.getFavorite().then((value) {
      print('valueData : ${json.decode(value)['data']}');
      if (json.decode(value)['data'] != null &&
          json.decode(value)['data'] != "" &&
          json.decode(value)['data'].length != 0) {
        print('check');
        List<dynamic> valueList = json.decode(value)['data'];

        for (int i = 0; i < valueList.length; i++) {
          favoriteData.add(FavoriteData(
              auth_id: valueList[i]['auth_id'],
              cafe_name: valueList[i]['cafe_name'],
              cafe_identify: valueList[i]['cafe_identify']));
        }

        print("favoriteDataLength : ${favoriteData.length}");

        String name = "";

        for (int i = 0; i < favoriteData.length; i++) {
          if (favoriteData.length == 1) {
            name += favoriteData[i].cafe_name;
          } else if (i == favoriteData.length) {
            name += favoriteData[i].cafe_name;
          } else {
            name += favoriteData[i].cafe_name + ",";
          }
        }

        print("name : ${name}");

        if (name.substring(name.length - 1).contains(",")) {
          name = name.substring(0, name.length - 1);
        }

        _mainBloc.setNameValue(name);
        _mainBloc.favoriteCafe().then((value) {
          List<dynamic> valueList = json.decode(value)['data'];

          for (int i = 0; i < valueList.length; i++) {
            favoriteCafeData.add(FavoriteCafeData(
                pic: valueList[i]['pic'],
                user_num: valueList[i]['user_num'],
                recent_num: valueList[i]['recent_num'],
                name: valueList[i]['name'],
                location: valueList[i]['location']));
          }

          print("favoriteCafeDataLength : ${favoriteCafeData.length}");

          for (int i = 0; i < favoriteCafeData.length; i++) {
            select.add(false);

            if (locationSet.length == 0) {
              locationSet.add(favoriteCafeData[i].location);
            } else {
              bool inData = false;
              for (int j = 0; j < locationSet.length; j++) {
                if (locationSet[j] == favoriteCafeData[i].location) {
                  inData = false;
                  break;
                } else {
                  inData = true;
                }
              }
              if (inData) {
                locationSet.add(favoriteCafeData[i].location);
              }
            }
          }

          for (int i = 0; i < locationSet.length; i++) {
            print("locationSet : ${locationSet[i]}");
          }

          setState(() {
            dataGet = true;
          });
        });
      } else {
        print('check2');
        setState(() {
          notData = true;
          dataGet = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    sharedInit();
  }

  bool touchedCafe = false;
  LatLng latLng;
  var location = new Location();
  var currentLocation;
  double distanceLocation;
  String imgUrl;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: White,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: dataGet
            ? notData
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 30, top: MediaQuery.of(context).size.height / 4),
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
                              "가고 싶은 카페를\n즐겨찾기 해보세요.",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "가고 싶은 카페를\n즐겨찾기 하고,\n언제든 다시 찾아볼 수 있어요.",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 122, 122, 122),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ))
                : Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "서울",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Black),
                            ),
                            whiteSpaceH(10),
                            deleteMode
                                ? Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              deleteMode = false;
                                            });
                                          },
                                          child: Text(
                                            "취소",
                                            style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ),
                                        whiteSpaceW(25),
                                        GestureDetector(
                                          onTap: () {
                                            String identify = "";
                                            for (int i = 0; i < selectIdentify.length; i++) {
                                              if (selectIdentify.length == 1) {
                                                identify += selectIdentify[i];
                                              } else if (i == selectIdentify.length) {
                                                identify += selectIdentify[i];
                                              } else {
                                                identify += selectIdentify[i] + ",";
                                              }
                                            }

                                            if (identify.substring(identify.length - 1).contains(",")) {
                                              identify = identify.substring(0, identify.length - 1);
                                            }

                                            _mainBloc.setFavoriteIdentify(identify);
                                            _mainBloc.deleteFavorite().then((value) {
                                              setState(() {
                                                favoriteData.clear();
                                                favoriteCafeData.clear();
                                                locationSet.clear();
                                                selectIdentify.clear();
                                                select.clear();
                                                dataGet = false;
                                                notData = false;
                                                getFavoriteData();
                                              });
                                            });
                                          },
                                          child: Text(
                                            "삭제",
                                            style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            deleteMode = true;
                                          });
                                        },
                                        child: Text(
                                          "선택",
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                            ListView.builder(
                              itemBuilder: (context, id) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      locationSet[id],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Black),
                                    ),
                                    whiteSpaceH(10),
                                    ListView.builder(
                                      itemBuilder: (context, idx) {
                                        print(
                                            "nameCheck : ${favoriteCafeData[idx].location}, ${locationSet[id]}");
                                        if (favoriteCafeData[idx].location ==
                                            locationSet[id]) {
                                          return GestureDetector(
                                              onTap: () {
                                                _mainBloc.setName(
                                                    favoriteCafeData[idx].name);
                                                _mainBloc
                                                    .getNaverData()
                                                    .then((value) async {
                                                  print("value : ${value}");
                                                  if (json.decode(value)[
                                                              'result'] !=
                                                          0 &&
                                                      (json.decode(value)[
                                                                  'data'] !=
                                                              null &&
                                                          json.decode(value)[
                                                                  'data'] !=
                                                              "")) {
                                                    setState(() {
                                                      touchedCafe = true;
                                                    });
                                                    NaverData naverData =
                                                        NaverData(
                                                      url: json.decode(
                                                          value)['data']['url'],
                                                      description: json.decode(
                                                              value)['data']
                                                          ['description'],
                                                      convenien: json.decode(
                                                              value)['data']
                                                          ['convenien'],
                                                      homepage: json.decode(
                                                              value)['data']
                                                          ['homepage'],
                                                      menu: json.decode(
                                                              value)['data']
                                                          ['menu'],
                                                      opentime: json.decode(
                                                              value)['data']
                                                          ['opentime'],
                                                      addr: json.decode(
                                                              value)['data']
                                                          ['addr'],
                                                      phone: json.decode(
                                                              value)['data']
                                                          ['phone'],
                                                      category: json.decode(
                                                              value)['data']
                                                          ['category'],
                                                      name: json.decode(
                                                              value)['data']
                                                          ['name'],
                                                      identify: json.decode(
                                                              value)['data']
                                                          ['identify'],
                                                      subname: json.decode(
                                                              value)['data']
                                                          ['subname'],
                                                    );

                                                    final query =
                                                        naverData.addr;
                                                    var address = await Geocoder
                                                        .local
                                                        .findAddressesFromQuery(
                                                            query);
                                                    var first = address.first;
                                                    print(
                                                        "coordinates : ${first.coordinates.latitude}, ${first.coordinates.longitude}");

                                                    latLng = LatLng(
                                                        first.coordinates
                                                            .latitude,
                                                        first.coordinates
                                                            .longitude);

                                                    try {
                                                      currentLocation =
                                                          await location
                                                              .getLocation();
                                                      print(
                                                          "currentLocation : ${currentLocation.latitude}, ${currentLocation.longitude}");

                                                      distanceLocation =
                                                          await Geolocator()
                                                              .distanceBetween(
                                                                  currentLocation
                                                                      .latitude,
                                                                  currentLocation
                                                                      .longitude,
                                                                  first
                                                                      .coordinates
                                                                      .latitude,
                                                                  first
                                                                      .coordinates
                                                                      .longitude);

                                                      print(
                                                          "distance : ${(double.parse(distanceLocation.toStringAsFixed(1)) / 1000).toStringAsFixed(1)}km");

                                                      _mainBloc
                                                          .getPopularPic()
                                                          .then((value) async {
                                                        if (json.decode(value)[
                                                                    'result'] !=
                                                                0 &&
                                                            json.decode(value)[
                                                                    'data'] !=
                                                                null) {
                                                          dynamic valueList =
                                                              await json.decode(
                                                                      value)[
                                                                  'data'];
                                                          imgUrl =
                                                              valueList['pic'];

                                                          setState(() {
                                                            touchedCafe = false;
                                                          });

                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    CafeDetail(
                                                              identify:
                                                                  naverData
                                                                      .identify,
                                                              cafeName:
                                                                  naverData
                                                                      .name,
                                                              phone: naverData
                                                                  .phone,
                                                              address: naverData
                                                                  .addr,
                                                              convenien:
                                                                  naverData
                                                                      .convenien,
                                                              distance: (double.parse(distanceLocation.toStringAsFixed(
                                                                              1)) /
                                                                          1000)
                                                                      .toStringAsFixed(
                                                                          1) +
                                                                  "km",
                                                              imgUrl: imgUrl,
                                                              menu: naverData
                                                                  .menu,
                                                              naverUrl:
                                                                  naverData.url,
                                                              subName: naverData
                                                                  .subname,
                                                              latLng: latLng,
                                                              openTime:
                                                                  naverData
                                                                      .opentime,
                                                            ),
                                                          ));
                                                        }
                                                      });
                                                    } on Exception catch (e) {
                                                      print(e.toString());
                                                      currentLocation = null;
                                                    }
                                                  } else {
                                                    CafeLogSnackBarWithOk(
                                                        msg:
                                                            "카페 정보가 부족하여 상세 정보를 볼 수 없습니다.",
                                                        context: context,
                                                        okMsg: "확인");
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 15,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 0,
                                                        ),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 44,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        White,
                                                                    borderRadius:
                                                                        BorderRadius.circular(8.0),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              219,
                                                                              219,
                                                                              219),
                                                                          blurRadius:
                                                                              7)
                                                                    ]),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              30),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                          70,
                                                                        child:
                                                                            Text(
                                                                          favoriteCafeData[idx]
                                                                              .name,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12,
                                                                              color: Black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
//                                                                        width:
//                                                                            50,
                                                                        child:
                                                                            Text(
                                                                          "다녀온 사람",
                                                                          style: TextStyle(
                                                                              color: Color.fromARGB(255, 167, 167, 167),
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600),
                                                                              textAlign: TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          favoriteCafeData[idx]
                                                                              .user_num
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 10,
                                                                              color: Black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 5),
                                                                        child:
                                                                            Container(
//                                                                          width:
//                                                                              35,
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Center(
                                                                                child: Text(
                                                                                  "최근1개월",
                                                                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: mainColor),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                              whiteSpaceH(1),
                                                                              Center(
                                                                                child: Text(
                                                                                  favoriteCafeData[idx].recent_num.toString(),
                                                                                  style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 8),
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
                                                            Positioned(
                                                              top: 2,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    favoriteCafeData[
                                                                            idx]
                                                                        .pic,
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 40,
                                                                    height: 40,
                                                                  ),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/defaultImage.png",
                                                                    width: 40,
                                                                    height: 40,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    deleteMode
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (!select[idx]) {
                                                                  setState(() {
                                                                    select[idx] = true;
                                                                    for (int i = 0; i < favoriteData.length; i++) {
                                                                      if (favoriteCafeData[idx].name == favoriteData[i].cafe_name){
                                                                        print('checkData : ${favoriteCafeData[idx].name}, ${favoriteData[i].cafe_name}');
                                                                        selectIdentify.add(favoriteData[i].cafe_identify);
                                                                        break;
                                                                      }
                                                                    }
                                                                  });
                                                                } else {
                                                                 setState(() {
                                                                   select[idx] = false;
                                                                   for (int i = 0; i < selectIdentify.length; i++) {
                                                                     if (favoriteData[idx].cafe_identify == selectIdentify[i]) {
                                                                       selectIdentify.removeAt(i);
                                                                       break;
                                                                     }
                                                                   }
                                                                 });
                                                                }
                                                              },
                                                              child: Container(
                                                                width: 15,
                                                                height: 15,
                                                                decoration: select[idx] ? BoxDecoration(
                                                                    color:
                                                                    mainColor,
                                                                    shape: BoxShape
                                                                        .circle) : BoxDecoration(
                                                                    color:
                                                                        White,
                                                                    border: Border.all(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            151,
                                                                            151,
                                                                            151),
                                                                        width:
                                                                            1),
                                                                    shape: BoxShape
                                                                        .circle),
                                                              ),
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                              ));
                                        }
                                        return Container();
                                      },
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: favoriteCafeData.length,
                                    ),
                                    whiteSpaceH(20)
                                  ],
                                );
                              },
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: locationSet.length,
                            )
                          ],
                        ),
                      ),
                      touchedCafe
                          ? Container(
                              height: MediaQuery.of(context).size.height - 150,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(mainColor),
                                ),
                              ))
                          : Container()
                    ],
                  )
            : Container(
                height: MediaQuery.of(context).size.height - 150,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ),
              ),
      ),
    );
  }
}
