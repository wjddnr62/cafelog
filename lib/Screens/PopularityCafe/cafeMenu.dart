import 'package:cafelog/Model/CafeMenuData.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';

class CafeMenu extends StatefulWidget {
  @override
  _CafeMenu createState() => _CafeMenu();
}

class _CafeMenu extends State<CafeMenu> {
  List<CafeMenuData> _cafeMenuData = List();
  List<String> menuNameList = List();

  menuAdd() {
    _cafeMenuData
      ..add(CafeMenuData(
          menuName: "아메리카노",
          atePerson: 675,
          menuImg: "assets/test/test1.png",
          menuType: "커피",
          popularityMenu: true,
          priceType: 0,
          price: 6000))
      ..add(CafeMenuData(
          menuName: "에스프레소",
          atePerson: 287,
          menuType: "커피",
          popularityMenu: true,
          priceType: 0,
          price: 6000,
          description: "콜롬비아, 코스타리카, 에티오피아, 과테말라, 인도네시아"))
      ..add(CafeMenuData(
          menuName: "아포가토",
          atePerson: 570,
          menuType: "커피",
          popularityMenu: true,
          priceType: 1,
          hot: 5000,
          ice: 6000,
          menuOptions: "톨 : +500원 그란데 : +1,000원",
          menuImg: "assets/test/test2.png"))
      ..add(CafeMenuData(
          menuName: "솜사탕 아포가토",
          atePerson: 883,
          menuType: "커피",
          popularityMenu: true,
          priceType: 0,
          price: 6000))
      ..add(CafeMenuData(
          menuName: "아스께끼",
          atePerson: 308,
          menuType: "디저트",
          priceType: 0,
          price: 6000,
          menuImg: "assets/test/test3.png"))
      ..add(CafeMenuData(
          menuName: "아메리칸 브렉퍼스트",
          atePerson: 841,
          menuType: "디저트",
          popularityMenu: true,
          priceType: 0,
          price: 44000,
          menuImg: "aseets/test/test4.png"))
      ..add(CafeMenuData(
          menuName: "뉴욕초코커피케이크",
          atePerson: 224,
          priceType: 0,
          price: 6000,
          menuType: "디저트"))
      ..add(CafeMenuData(
          menuName: "커피프라페",
          atePerson: 930,
          price: 6000,
          menuType: "프라페",
          priceType: 0,
          menuImg: "assets/test/test5.png"))
      ..add(CafeMenuData(
          menuName: "그린티프라페",
          menuType: "프라페",
          atePerson: 149,
          price: 6000,
          priceType: 0));

    for (int i = 0; i < _cafeMenuData.length; i++) {
      if (menuNameList.length == 0) {
        menuNameList.add(_cafeMenuData[i].menuType);
      } else {
        bool equals = false;
        for (int j = 0; j < menuNameList.length; j++) {
          if (menuNameList[j] == _cafeMenuData[i].menuType) {
            equals = true;
            break;
          } else {
            equals = false;
          }
        }

        if (!equals) {
          menuNameList.add(_cafeMenuData[i].menuType);
        }
      }
    }

    for (int i = 0; i < menuNameList.length; i++) {
      print("카페 메뉴 : " + menuNameList[i]);
    }
  }

  @override
  void initState() {
    super.initState();

    menuAdd();
  }

  String selectMenu = "전체메뉴";
  bool menuOptions = true;

  topMenu(List menuList) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, idx) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (idx == 0) {
                  selectMenu = "전체메뉴";
                } else {
                  selectMenu = menuList[idx - 1];
                }
              });
            },
            child: Container(
              padding: EdgeInsets.only(right: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  idx == 0
                      ? Text(
                          "전체메뉴",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectMenu == "전체메뉴"
                                  ? Black
                                  : Color.fromARGB(255, 167, 167, 167),
                              fontSize: 24),
                        )
                      : Text(
                          menuList[idx - 1],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectMenu ==
                                      (idx != 0 ? menuList[idx - 1] : null)
                                  ? Black
                                  : Color.fromARGB(255, 167, 167, 167),
                              fontSize: 24),
                        ),
                  whiteSpaceH(5),
                  selectMenu == (idx != 0 ? menuList[idx - 1] : "전체메뉴")
                      ? Center(
                          child: Text(
                            "￣",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Black,
                                fontSize: 24),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        },
        itemCount: menuList.length + 1,
        shrinkWrap: true,
//        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              whiteSpaceH(15),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 55,
                      child: topMenu(menuNameList),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 10),
                      child: MediaQuery.removePadding(
                        context: context,
                        child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(right: 10),
                          itemBuilder: (context, idx) {
                            return selectMenu == "전체메뉴"
                                ? idx == menuNameList.length + 1
                                ? Container()
                                : idx == 0
                                ? menuOptions
                                ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "인기",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Black,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "* 샷추가 300원, 테이크아웃시 500원 할인",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Black,
                                      fontSize: 10),
                                )
                              ],
                            )
                                : Text(
                              "인기",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Black,
                                  fontWeight: FontWeight.bold),
                            )
                                : Text(
                              idx == 0 ? "" : menuNameList[idx - 1],
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Black,
                                  fontWeight: FontWeight.bold),
                            )
                                : Container();
                          },
                          separatorBuilder: (context, idx) {
                            int menuNum = 0;
                            return Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: selectMenu == "전체메뉴"
                                  ? idx == 0
                                  ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, num) {
                                  if (_cafeMenuData[num].popularityMenu !=
                                      null) {
                                    if (_cafeMenuData[num]
                                        .popularityMenu ==
                                        true) {
                                      menuNum++;
                                      return Row(
                                        children: <Widget>[
                                          Text("${menuNum}"),
                                          Text("${_cafeMenuData[num].menuName}")
                                        ],
                                      );
                                    }
                                  }
                                  return Container();
                                },
                                shrinkWrap: true,
                                itemCount: _cafeMenuData.length,
                              )
                                  : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, num) {
                                    if (menuNameList[idx - 1] == _cafeMenuData[num].menuType) {
                                      menuNum++;
                                      return Row(
                                        children: <Widget>[
                                          Text("${menuNum}"),
                                          Text("${_cafeMenuData[num].menuName}")
                                        ],
                                      );
                                    }
                                  return Container();
                                },
                                shrinkWrap: true,
                                itemCount: _cafeMenuData.length,
                              )
                                  : Container(),
                            );
                          },
                          itemCount: menuNameList.length + 2,
                          shrinkWrap: true,
                        ),
                        removeTop: true,
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
