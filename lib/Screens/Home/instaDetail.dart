import 'dart:convert';

import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/naverData.dart';
import 'package:cafelog/Screens/PopularityCafe/cafeDetail.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstaDetail extends StatefulWidget {
  String instaUrl;
  String name;
  double offset;
  int type;

  InstaDetail({Key key, this.instaUrl, this.name, this.offset, this.type})
      : super(key: key);

  @override
  _InstaDetail createState() => _InstaDetail();
}

class _InstaDetail extends State<InstaDetail> {
  MainBloc _mainBloc = MainBloc();

  WebViewController _webViewController;
  String loadCompleteUrl;
  bool firstLoad = false;
  bool getData = false;

  var location = new Location();
  var currentLocation;
  double distanceLocation;

  slidingUpPanelBody() => SlidingUpPanel(
      minHeight: widget.type == 0 ? 60 : 0,
      maxHeight: widget.type == 0 ? 60 : 0,
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
        height: 60,
      ),
      collapsed: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: !getData
            ? Center(
                child: Text(
                  "표시할 카페 정보가 없습니다.",
                  style: TextStyle(
                      fontSize: 16, color: Black, fontWeight: FontWeight.w600),
                ),
              )
            : GestureDetector(
                onTap: () {
                  print("touch");
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CafeDetail(
                    cafeName: naverData.name,
                    identify: naverData.identify,
                    phone: naverData.phone,
                    address: naverData.addr,
                    convenien: naverData.convenien,
                    distance: (double.parse(distanceLocation
                        .toStringAsFixed(1)) /
                        1000)
                        .toStringAsFixed(1) +
                        "km",
                    imgUrl: imgUrl,
                    menu: naverData.menu,
                    naverUrl: naverData.url,
                    subName: naverData.subname,
                    latLng: latLng,
                    openTime: naverData.opentime,
                  ),));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: White,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 15, left: 25, right: 25),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                child: ClipOval(
                                  child: ClipRRect(
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              whiteSpaceW(5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          naverData.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Black),
                                        ),
                                        whiteSpaceW(5),
                                        Text(
                                          (double.parse(distanceLocation
                                                          .toStringAsFixed(1)) /
                                                      1000)
                                                  .toStringAsFixed(1) +
                                              "km",
                                          style: TextStyle(
                                              fontSize: 12, color: Black),
                                        )
                                      ],
                                    ),
                                    whiteSpaceH(2),
                                    Text(
                                      naverData.addr,
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 135, 135, 135),
                                          fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward)
                            ],
                          ),
                        )
                      ],
                    )),
              ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: widget.type == 0 ? 85 : 25),
        child: WebView(
          initialUrl: widget.instaUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (_webController) {
            _webController.clearCache();
            _webViewController = _webController;
          },
          onPageFinished: (url) {
            if (firstLoad == false) {
              loadCompleteUrl = url;
              firstLoad = true;
            }
          },
        ),
      ));

  backFab() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(widget.offset);
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

  NaverData naverData;
  String imgUrl;
  LatLng latLng;

  @override
  void initState() {
    super.initState();

    print("getName : ${widget.name}");
    _mainBloc.setName(widget.name);

    _mainBloc.getNaverData().then((value) async {
      if (json.decode(value)['result'] != 0 &&
          json.decode(value)['data'] != null) {
        print("naverData : ${json.decode(value)['data']}");
        dynamic valueList = await json.decode(value)['data'];
        naverData = NaverData(
            url: valueList['url'],
            identify: valueList['identify'],
            name: valueList['name'],
            category: valueList['category'],
            subname: valueList['subname'],
            phone: valueList['phone'],
            addr: valueList['addr'],
            opentime: valueList['opentime'],
            menu: valueList['menu'],
            homepage: valueList['homepage'],
            convenien: valueList['convenien'],
            description: valueList['description']);

        final query = naverData.addr;
        var address = await Geocoder.local.findAddressesFromQuery(query);
        var first = address.first;
        print(
            "coordinates : ${first.coordinates.latitude}, ${first.coordinates.longitude}");

        latLng = LatLng(first.coordinates.latitude, first.coordinates.longitude);

        try {
          currentLocation = await location.getLocation();
          print(
              "currentLocation : ${currentLocation.latitude}, ${currentLocation.longitude}");

          distanceLocation = await Geolocator().distanceBetween(
              currentLocation.latitude,
              currentLocation.longitude,
              first.coordinates.latitude,
              first.coordinates.longitude);

          print(
              "distance : ${(double.parse(distanceLocation.toStringAsFixed(1)) / 1000).toStringAsFixed(1)}km");
        } on Exception catch (e) {
          print(e.toString());
          currentLocation = null;
        }
        _mainBloc.getPopularPic().then((value) async {
          if (json.decode(value)['result'] != 0 &&
              json.decode(value)['data'] != null) {
            dynamic valueList = await json.decode(value)['data'];
            imgUrl = valueList['pic'];
            print("imgUrl : ${imgUrl}");
            setState(() {
              getData = true;
            });
          }
        });

        print("naverCheck : ${naverData.url}");
      } else {
        print("notData");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        if (loadCompleteUrl == null) {
          Navigator.of(context).pop(widget.offset);
        } else {
          _webViewController.currentUrl().then((value) {
            if (value != loadCompleteUrl) {
              _webViewController.goBack();
            } else {
              Navigator.of(context).pop(widget.offset);
            }
          });
        }
        return null;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: White,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              slidingUpPanelBody(),
              Padding(
                padding: EdgeInsets.only(right: 30, bottom: 100),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: backFab(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
