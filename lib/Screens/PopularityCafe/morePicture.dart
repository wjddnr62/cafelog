import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Model/morePictureData.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../colors.dart';

class MorePicture extends StatefulWidget {
  @override
  _MorePicture createState() => _MorePicture();
}

class _MorePicture extends State<MorePicture> {
  List<MorePictureData> morePictureLeftData = List();
  List<MorePictureData> morePictureRightData = List();
  List<int> typeLength = [0, 0, 0, 0];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 60; i++) {
      List<String> image = List();
      if (i >= 0 && i < 30) {
        if (i == 2) {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          image.add("assets/test/test${i + 2}.png");
          morePictureLeftData.add(MorePictureData(image, "@test${i}", "", 2));
        } else if (i >= 10) {
          image.clear();
          if (i.toString().contains("9")) {
            image.add("assets/test/test${(i).toString().substring(0, 1)}.png");
          } else {
            image.add("assets/test/test${(i + 1).toString().substring(0, 1)}.png");
          }
          morePictureLeftData.add(MorePictureData(image, "@test${i}", "", 1));
        } else {
          image.clear();
          if (i.toString().contains("9")) {
            image.add("assets/test/test${(i).toString().substring(0, 1)}.png");
          } else {
            image.add("assets/test/test${(i + 1).toString().substring(0, 1)}.png");
          }
          morePictureLeftData.add(MorePictureData(image, "@test${i}", "", 0));
        }
      } else if (i >= 30 && i < 60) {
        if (i == 32) {
          image.clear();
          image.add("assets/test/test${1}.png");
          image.add("assets/test/test${2}.png");
          morePictureRightData.add(MorePictureData(image, "@test${i}", "", 3));
        } else {
          image.clear();
          if (i.toString().contains("9")) {
            image.add("assets/test/test${(i).toString().substring(0, 1)}.png");
          } else {
            image.add("assets/test/test${(i + 1).toString().substring(0, 1)}.png");
          }
          morePictureRightData.add(MorePictureData(image, "@test${i}", "", 0));
        }
      }
    }

    // type : 0 = 업체사진, 1 = 매장사진, 2 = 메뉴사진, 3 = 카페에서
    for (int i = 0; i < morePictureLeftData.length; i++) {
      if (morePictureLeftData[i].type == 0) {
        typeLength[0] += 1;
      } else if (morePictureLeftData[i].type == 1) {
        typeLength[1] += 1;
      } else if (morePictureLeftData[i].type == 2) {
        typeLength[2] += 1;
      } else if (morePictureLeftData[i].type == 3) {
        typeLength[3] += 1;
      }
    }

    for (int i = 0; i < morePictureRightData.length; i++) {
      if (morePictureRightData[i].type == 0) {
        typeLength[0] += 1;
      } else if (morePictureRightData[i].type == 1) {
        typeLength[1] += 1;
      } else if (morePictureRightData[i].type == 2) {
        typeLength[2] += 1;
      } else if (morePictureRightData[i].type == 3) {
        typeLength[3] += 1;
      }
    }

    for (int i = 0; i < typeLength.length; i++) {
      print("typeLength : " + typeLength[i].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: <Widget>[
            whiteSpaceH(10),
            Text(
              "카페사진",
              style: TextStyle(
                  fontSize: 18, color: Black, fontWeight: FontWeight.bold),
            ),
            whiteSpaceH(10),
            Row(
              children: <Widget>[],
            )
          ],
        ),
      ),
    );
  }
}
