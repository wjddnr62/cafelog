import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/cafeGoogleData.dart';
import 'package:cafelog/Model/cafeListData.dart';
import 'package:cafelog/Model/naverData.dart';
import 'package:cafelog/Screens/PopularityCafe/cafeDetail.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/Widgets/snackbar.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleDetail extends StatefulWidget {
  String searchItem;
  String image;
  String cafeName;
  String title;
  String link;
  String location;
  double homeOffset;
  double detailOffset;

  GoogleDetail(
      {Key key,
      this.searchItem,
      this.image,
      this.cafeName,
      this.title,
      this.link,
      this.location,
      this.homeOffset,
      this.detailOffset})
      : super(key: key);

  @override
  _GoogleDetail createState() => _GoogleDetail();
}

class _GoogleDetail extends State<GoogleDetail> {
  ScrollController _scrollController = ScrollController();

  checkEndList() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        firstData = false;
//        mainListGrid();
      });
//      setState(() {});
//      });
      print("bottom");
    }
  }

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  locationCheck() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  @override
  void initState() {
    _scrollController.addListener(checkEndList);
    super.initState();
    mainBloc.setName(widget.cafeName);
    locationCheck();

    getNaverData();
  }

  NaverData naverData = null;
  bool getData = false;
  var location = new Location();
  var currentLocation;
  double distanceLocation;
  String km = "";

  getNaverData() {
    mainBloc.getNaverData().then((value) async {
      print("value : ${value}");
      if (json.decode(value)['result'] != 0 &&
          (json.decode(value)['data'] != null &&
              json.decode(value)['data'] != "")) {
        naverData = NaverData(
          url: json.decode(value)['data']['url'],
          description: json.decode(value)['data']['description'],
          convenien: json.decode(value)['data']['convenien'],
          homepage: json.decode(value)['data']['homepage'],
          menu: json.decode(value)['data']['menu'],
          opentime: json.decode(value)['data']['opentime'],
          lat: json.decode(value)['data']['lat'],
          lon: json.decode(value)['data']['lon'],
          addr: json.decode(value)['data']['addr'],
          phone: json.decode(value)['data']['phone'],
          category: json.decode(value)['data']['category'],
          name: json.decode(value)['data']['name'],
          identify: json.decode(value)['data']['identify'],
          subname: json.decode(value)['data']['subname'],
        );

        if (_serviceEnabled) {
          currentLocation = await location.getLocation();
          print(
              "currentLocation : ${currentLocation.latitude}, ${currentLocation.longitude}");

          distanceLocation = await Geolocator().distanceBetween(
              currentLocation.latitude,
              currentLocation.longitude,
              double.parse(naverData.lat),
              double.parse(naverData.lon));

          km = (double.parse(distanceLocation.toStringAsFixed(1)) / 1000)
                  .toStringAsFixed(1) +
              "km";
        }

        setState(() {
          print('true!!0');
          getData = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(widget.homeOffset);
        return null;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: White,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: White,
            elevation: 0.0,
            centerTitle: true,
            title: widget.searchItem == "instagram posts" ? Image.asset("assets/instalogo.png", fit: BoxFit.fill, width: 25, height: 25,) : Image.asset("assets/naverlogo.png", fit: BoxFit.fill, width: 25, height: 25,),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(widget.homeOffset);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width + 35,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          imageUrl: widget.image,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(mainColor),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.width - 30,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CafeDetail(
                                    cafeName: widget.cafeName,
                                    identify: naverData.identify,
                                    openTime: naverData.opentime,
                                    latLng: LatLng(double.parse(naverData.lat), double.parse(naverData.lon)),
                                    subName: naverData.subname,
                                    naverUrl: naverData.url,
                                    menu: naverData.menu,
                                    imgUrl: widget.image,
                                    distance: km,
                                    convenien: naverData.convenien,
                                    address: naverData.addr,
                                    phone: naverData.phone,
                                  ),
                                )
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: White,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 167, 167, 167),
                                      blurRadius: 5)
                                ],
                              ),
                              child: !getData
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                mainColor),
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ClipOval(
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              child: CachedNetworkImage(
                                                imageUrl: widget.image,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          whiteSpaceW(5),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(widget.cafeName, style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 16, color: Black
                                                ),),
                                                whiteSpaceH(2),
                                                Text(km, style: TextStyle(
                                                  fontSize: 12, color: Black
                                                ),)
                                              ],
                                            ),
                                          ),
                                          Icon(Icons.arrow_forward, color: Black,)
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                whiteSpaceH(40),
                GestureDetector(
                  onTap: () {
                    launch(widget.link);
                  },
                  child: Text(
                    widget.title,
                    style: TextStyle(color: Black, fontSize: 10),
                  ),
                ),
                whiteSpaceH(40),
                RaisedButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19)),
                  color: Color.fromARGB(255, 247, 247, 247),
                  elevation: 0.0,
                  child: Container(
                    width: 90,
                    height: 40,
                    child: Center(
                      child: Text(
                        "가고싶어요",
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                whiteSpaceH(100),
                mainListGrid()
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool firstData = false;
  int defaultOffSet = 0;
  List<CafeGoogleData> _cafeList = List();

  mainListGrid() {
    if (!firstData) {
      mainBloc.setLimit(defaultOffSet);

      mainBloc.getCafeList().then((value) async {
        if (json.decode(value)['result'] != 0 &&
            (json.decode(value)['data'] != null &&
                json.decode(value)['data'] != "" &&
                json.decode(value)['data'].length != 0)) {
          if (!firstData) {
            defaultOffSet += 1;
            print('value : ${json.decode(value)['data']}');
            List<dynamic> valueList = await json.decode(value)['data'];
            print(valueList.length);
            if (valueList.length != 0) {
              for (int i = 0; i < valueList.length; i++) {
                _cafeList.add(CafeGoogleData(
                    idx: valueList[i]['idx'],
                    search_item: valueList[i]['search_item'],
                    keyword: valueList[i]['keyword'],
                    cafe_name: valueList[i]['cafe_name'],
                    title: valueList[i]['title'],
                    url: valueList[i]['url'],
                    image: valueList[i]['image'],
                    thumbnail: valueList[i]['thumbnail'],
                    location: valueList[i]['location']));
              }
            }
            firstData = true;
          }
          setState(() {});
        } else {
          setState(() {
            firstData = true;
          });
          CafeLogSnackBarWithOk(
              context: context, okMsg: "확인", msg: "더 이상 표시할 카페 기록이 없습니다.");
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
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              itemCount: _cafeList.length,
              itemBuilder: (context, idx) => GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleDetail(
                          title: _cafeList[idx].title,
                          image: _cafeList[idx].image,
                          cafeName: _cafeList[idx].cafe_name,
                          link: _cafeList[idx].url,
                          searchItem: _cafeList[idx].search_item,
                          location: _cafeList[idx].location,
                          homeOffset: widget.homeOffset,
                          detailOffset: _scrollController.offset,
                        ),
                      ));
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
                              imageUrl: _cafeList[idx].image,
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/defaultImage.png",
                                fit: BoxFit.fill,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              staggeredTileBuilder: (idx) => StaggeredTile.fit(1),
              crossAxisSpacing: 10.0,
            ));
  }
}
