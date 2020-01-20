import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyAroundMap extends StatefulWidget {
  LatLng latLng;

  MyAroundMap({Key key, this.latLng}) : super(key: key);

  @override
  _MyAroundMap createState() => _MyAroundMap();
}

class _MyAroundMap extends State<MyAroundMap> {
  GoogleMapController _controller;
  static LatLng _latLng;
  Location location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();

    _latLng = widget.latLng;
    markerAdd(_latLng);
  }

  markerAdd(latLng) {
    final MarkerId markerId = MarkerId("1");
    _latLng = latLng;

    final Marker marker = Marker(markerId: markerId, position: latLng);

    setState(() {
      markers[markerId] = marker;
    });
  }

  static final CameraPosition _initPlex =
      CameraPosition(target: _latLng, zoom: 14);

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

  floatingActionButton(type) {
    return FloatingActionButton(
      onPressed: () {
        type == 0 ? moveMyLocation() : Navigator.of(context).pop();
      },
      backgroundColor: White,
      heroTag: type == 0 ? "myLocation" : "back",
      child: Center(
        child: type == 0
            ? Text(
                "현위치로",
                style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 12),
              )
            : Icon(
                Icons.arrow_back,
                color: mainColor,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: White,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                onCameraMove: (position) {
                  markerAdd(position.target);
                },
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: _latLng, zoom: 14)));
                },
              ),
            ),
            Positioned(child: floatingActionButton(0), bottom: 85, right: 15,),
            Positioned(child: floatingActionButton(1), bottom: 20, right: 15,),
            Positioned.fill(child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(_latLng);
                },
                child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.5),
                      color: mainColor
                  ),
                  child: Center(
                    child: Text("핀 위치를 내 위치로 설정", style: TextStyle(
                      color: White, fontSize: 14, fontWeight: FontWeight.w600
                    ),),
                  ),
                ),
              ),
            ), bottom: 95,)
          ],
        ),
      ),
    );
  }
}
