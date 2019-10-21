import 'dart:async';
import 'dart:io';

import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/Widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../colors.dart';

class CafeLocation extends StatefulWidget {
  LatLng latLng;
  String cafeAddress;

  CafeLocation({Key key, this.latLng, this.cafeAddress}) : super(key: key);

  @override
  _CafeLocation createState() => _CafeLocation();
}

class _CafeLocation extends State<CafeLocation> {
  Completer<GoogleMapController> _map = Completer();
  GoogleMapController _controller;
  static LatLng _latLng;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Location location = Location();
  String cafeAddress;
  List<Map<String, String>> installedApps;
  List<Map<String, String>> iosApps;
  bool upPanel = false;

  markerAdd() {
    final MarkerId markerId = MarkerId("1");

    final Marker marker = Marker(markerId: markerId, position: _latLng);

    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<LatLng> getLocation() async {
    LatLng latLng;
    await location.getLocation().then((value) {
      latLng = LatLng(value.latitude, value.longitude);
    });

    return latLng;
  }

  moveMyLocation() {
    getLocation().then((value) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: value, zoom: 14)));
    });
  }

  Future<void> getApps() async {
    List<Map<String, String>> _installedApps;

    if (Platform.isAndroid) {
      _installedApps = await AppAvailability.getInstalledApps();
    } else if (Platform.isIOS) {
      _installedApps = iosApps;
    }

    setState(() {
      installedApps = _installedApps;
    });
  }

  @override
  void initState() {
    super.initState();

    _latLng = widget.latLng;
    cafeAddress = widget.cafeAddress;
    markerAdd();

    iosApps = [
      {"package_name": "kakaonavi://"},
      {"package_name": "nmap://"},
      {"package_name": "tmap://"}
    ];
  }

  static final CameraPosition _initPlex =
      CameraPosition(target: _latLng, zoom: 14);

  PanelController _panelController = PanelController();

  double panelHeight = 0;

  appLaunch(type) {
    String package;
    if (Platform.isAndroid) {
      if (type == 0) {
        package = "com.locnall.KimGiSa";
      } else if (type == 1) {
        package = "com.nhn.android.nmap";
      } else if (type == 2) {
        package = "com.skt.tmap.ku";
      }
      AppAvailability.launchApp(package).then((_) {}).catchError((err) {
        CafeLogSnackBarWithOk(
            okMsg: "확인", context: context, msg: "해당 앱이 설치되어 있지 않습니다.");
      });
    } else if (Platform.isIOS) {
      AppAvailability.launchApp(installedApps[type]["package_name"])
          .then((_) {})
          .catchError((err) {
        CafeLogSnackBarWithOk(
            okMsg: "확인", context: context, msg: "해당 앱이 설치되어 있지 않습니다.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (installedApps == null) getApps();

    return WillPopScope(
      onWillPop: () {
        if (panelHeight > 0) {
          setState(() {
            panelHeight = 0;
            upPanel = false;
          });
        } else {
          Navigator.of(context).pop();
        }
        return null;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: White,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (panelHeight > 0) {
                setState(() {
                  panelHeight = 0;
                  upPanel = false;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Icon(
              Icons.arrow_back,
              color: mainColor,
            ),
            backgroundColor: Colors.white,
            elevation: 0.6,
          ),
          body: SlidingUpPanel(
            controller: _panelController,
            minHeight: panelHeight,
            maxHeight: panelHeight,
            isDraggable: false,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            backdropEnabled: true,
            backdropTapClosesPanel: true,
            backdropColor: Color.fromRGBO(0, 0, 0, 0.6),
            color: White,
            panel: Container(),
            collapsed: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: GestureDetector(
                      onTap: () {
                        appLaunch(2);
                        setState(() {
                          panelHeight = 0;
                          upPanel = false;
                        });
                      },
                      child: Text(
                        "카카오내비로 길찾기",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      appLaunch(1);
                      setState(() {
                        panelHeight = 0;
                        upPanel = false;
                      });
                    },
                    child: Text(
                      "네이버지도로 길찾기",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      appLaunch(0);
                      setState(() {
                        panelHeight = 0;
                        upPanel = false;
                      });
                    },
                    child: Text(
                      "T맵으로 길찾기",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Black),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: _initPlex,
                      markers: Set<Marker>.of(markers.values),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                    ),
                  ),
                  Positioned(
                      left: 15,
                      right: 15,
                      bottom: 120,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: White,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 167, 167, 167),
                                blurRadius: 7)
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                cafeAddress,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 63, 61, 61),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      moveMyLocation();
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 240, 240, 240),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "내위치찾기",
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  whiteSpaceW(20),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        upPanel = true;
                                        panelHeight = 150;
                                      });
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 240, 240, 240),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "길찾기",
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  upPanel
                      ? Positioned.fill(
                          child: GestureDetector(
                          onTap: () {
                            setState(() {
                              panelHeight = 0;
                              upPanel = false;
                            });
                          },
                          child: Container(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ),
                        ))
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
