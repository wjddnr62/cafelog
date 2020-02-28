import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/streetsData.dart';
import 'package:cafelog/Screens/PopularityCafe/cafeLocation.dart';
import 'package:cafelog/Util/numberFormat.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:cafelog/Model/cafeLocationData.dart';
import 'package:intl/intl.dart';

class LocationSearch extends StatefulWidget {
  String cafeLocation;

  LocationSearch({Key key, this.cafeLocation}) : super(key: key);

  @override
  _LocationSearch createState() => _LocationSearch();
}

class _LocationSearch extends State<LocationSearch> {
  MainBloc _mainBloc = MainBloc();
  String cafeLoadTitle = "";
  List<CafeLocationData> _cafeList = List();
  String cafeLocation;

  @override
  void initState() {
    super.initState();

    cafeLocation = widget.cafeLocation;

    cafeLoadTitle = "서울";
  }

  cafeListGrid() => StreamBuilder(
        stream: _mainBloc.getCafeLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> valueList =
                json.decode(snapshot.data)['data'];
            _cafeList.clear();

            for (int i = 0; i < valueList.length; i++) {
              print(valueList[i]['image']);
              _cafeList.add(CafeLocationData(
                  user_num: valueList[i]['user_num'],
                  cafe_num: valueList[i]['cafe_num'],
                  location: valueList[i]['location'],
                  image: valueList[i]['image']));
            }

            if (_cafeList != null &&
                _cafeList.isNotEmpty &&
                _cafeList.length >= 0)
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 5.0,
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height /
                        0.85),
                itemCount: _cafeList.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: idx % 2 == 0
                        ? EdgeInsets.only(left: 15)
                        : EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        print("선택");

                        Navigator.of(context).pop(_cafeList[idx].location);
                      },
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: 280,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 280,
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 80),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: White,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 219, 219, 219),
                                                blurRadius: 7),
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 90),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Text(
                                                "# ${_cafeList[idx].location}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: Text(
                                                "카페 ${_cafeList[idx].cafe_num} 곳",
                                                style: TextStyle(
                                                    fontSize: 12, color: Black),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                "다녀온 사람 ${numberFormat.format(_cafeList[idx].user_num)} 명",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 167, 167, 167),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 5.0, right: 5.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 160,
                                        decoration: BoxDecoration(
                                            color: White,
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 219, 219, 219),
                                                  blurRadius: 7),
                                            ]),
                                        child: CachedNetworkImage(
                                          imageUrl: _cafeList[idx].image,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                              width: 170,
                                              height: 160,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              "assets/defaultImage.png",
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
//                                    Image.asset(
//                                      _cafeList[idx].img,
//                                      fit: BoxFit.fill,
//                                      width: 170,
//                                      height: 160,
//                                    ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(cafeLocation);

        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: White,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).padding.top + 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[

//                          Positioned.fill(
//                            top: 30,
//                            child:
                            Expanded(
                              child: Text(
                                cafeLoadTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Black),
                                textAlign: TextAlign.left,
                              ),
                            ),
//                          ),
                          GestureDetector(
                            onTap: () {
                              print("전체 카페 보기");
                              Navigator.of(context).pop("전체카페");
                            },
                            child: Container(
//                              child: Positioned(
//                                top: 40,
//                                right: 0,
                              child: Text(
                                "전체 카페 보기",
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
//                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                whiteSpaceH(10),
                Flexible(
                  child: MediaQuery.removePadding(context: context, child: cafeListGrid(), removeTop: true,),
                )
//                Expanded(
//                  child: cafeListGrid(),
//                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop(cafeLocation);
          },
          child: Icon(
            Icons.arrow_back,
            color: mainColor,
          ),
          backgroundColor: Colors.white,
          elevation: 0.6,
        ),
      ),
    );
  }
}
