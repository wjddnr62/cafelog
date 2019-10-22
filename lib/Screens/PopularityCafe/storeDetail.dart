import 'package:cafelog/Model/businessHoursData.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/main.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';

class StoreDetail extends StatefulWidget {
  @override
  _StoreDetail createState() => _StoreDetail();
}

class _StoreDetail extends State<StoreDetail> {
  List<BusinessHoursData> _bhList = List();
  bool isOpen = false;
  List<String> convenienceTag = List();

  @override
  void initState() {
    super.initState();

    _bhList.add(BusinessHoursData(day: "월요일", time: "오전 10:00 ~ 오후 10:00"));
    _bhList.add(BusinessHoursData(day: "화요일", time: "오전 10:00 ~ 오후 10:00"));
    _bhList.add(BusinessHoursData(day: "수요일", time: "오전 10:00 ~ 오후 10:00"));
    _bhList.add(BusinessHoursData(day: "목요일", time: "오전 10:00 ~ 오후 10:00"));
    _bhList.add(BusinessHoursData(day: "금요일", time: "오전 10:00 ~ 오후 10:00"));
    _bhList.add(BusinessHoursData(day: "토요일", time: "오전 10:00 ~ 오후 10:00"));
    _bhList.add(BusinessHoursData(day: "일요일", time: "오전 10:00 ~ 오후 10:00"));
    _bhList.add(BusinessHoursData(day: "공휴일", time: "휴일"));

    convenienceTag..add("주차가능")..add("반려견출입가능")..add("노키즈존")..add("공기청정기");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          color: mainColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0.6,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              whiteSpaceH(50),
              Text(
                "매장 상세정보",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: Black),
              ),
              whiteSpaceH(40),
              Text(
                "영업시간",
                style: TextStyle(
                    color: Black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              whiteSpaceH(30),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  if (idx == 4) {
                    return Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${_bhList[idx].day}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 102, 102, 102)),
                          ),
                          whiteSpaceW(5),
                          Text(
                            "${_bhList[idx].time}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 102, 102, 102)),
                          )
                        ],
                      ),
                    );
                  } else if (idx == 7) {
                    return Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3.6),
                            child: Text(
                              "${_bhList[idx].day}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 102, 102, 102)),
                            ),
                          ),
                          whiteSpaceW(MediaQuery.of(context).size.width / 6.5),
                          Text(
                            "${_bhList[idx].time}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: mainColor),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${_bhList[idx].day}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Black,
                                fontWeight: FontWeight.w600),
                          ),
                          whiteSpaceW(5),
                          Text(
                            "${_bhList[idx].time}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    );
                  }
                },
                shrinkWrap: true,
                itemCount: _bhList.length,
              ),
              whiteSpaceH(40),
              isOpen
                  ? Text(
                "현재 영업중",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 145, 255), fontSize: 14),
              )
                  : Text("현재 영업종료",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 145, 255), fontSize: 14)),
              whiteSpaceH(110),
              Text(
                "편의시설",
                style: TextStyle(
                    fontSize: 18, color: Black, fontWeight: FontWeight.bold),
              ),
              whiteSpaceH(35),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        "#${convenienceTag[idx]}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Black, fontSize: 16),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                itemCount: convenienceTag.length,
              ),
              whiteSpaceH(40)
            ],
          ),
      ),
    );
  }
}
