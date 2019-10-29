import 'package:cafelog/Model/CafeMenuData.dart';
import 'package:cafelog/Util/numberFormat.dart';
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
          menuImg: "assets/test/test4.png"))
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

  listSet(idx, menuNum) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, num) {
        if (idx != 0) {
          if (menuNameList[idx - 1] == _cafeMenuData[num].menuType) {
            menuNum++;
            return Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
                height: _cafeMenuData[num].menuOptions != null ? 90 : 70,
                child: Stack(
                  children: <Widget>[
                    whiteSpaceW(15),
                    Positioned.fill(
                      left: 30,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: White,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 167, 167, 167),
                                blurRadius: 7)
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _cafeMenuData[num].menuImg != null
                                ? whiteSpaceW(40)
                                : whiteSpaceW(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: _cafeMenuData[num].description != null
                                        ? 2
                                        : 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "${_cafeMenuData[num].menuName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Black),
                                      ),
                                    ),
                                  ),
                                  _cafeMenuData[num].description != null
                                      ? Expanded(
                                          child: Text(
                                            _cafeMenuData[num].description,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 106, 106, 106),
                                              fontSize: 10,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "먹어본 사람",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 167, 167, 167),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        _cafeMenuData[num].priceType == 0
                                            ? whiteSpaceW(20)
                                            : whiteSpaceW(10),
                                        Expanded(
                                          child: Text(
                                            _cafeMenuData[num]
                                                .atePerson
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                                color: Black),
                                          ),
                                        ),
                                        whiteSpaceW(10),
//                                                                        Spacer(flex: 1,),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: _cafeMenuData[num].priceType ==
                                                  0
                                              ? Text(
                                                  "${numberFormat.format(_cafeMenuData[num].price)}원",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          255, 102, 102, 102)),
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    ClipOval(
                                                      child: Container(
                                                        width: 10,
                                                        height: 10,
                                                        color: Color.fromARGB(
                                                            255, 224, 32, 32),
                                                      ),
                                                    ),
                                                    whiteSpaceW(3),
                                                    Text(
                                                      "${numberFormat.format(_cafeMenuData[num].hot)}원",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              102,
                                                              102,
                                                              102),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    whiteSpaceW(5),
                                                    ClipOval(
                                                      child: Container(
                                                        width: 10,
                                                        height: 10,
                                                        color: Color.fromARGB(
                                                            255, 0, 145, 255),
                                                      ),
                                                    ),
                                                    whiteSpaceW(3),
                                                    Text(
                                                      "${numberFormat.format(_cafeMenuData[num].ice)}원",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              102,
                                                              102,
                                                              102),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        whiteSpaceW(10)
                                      ],
                                    ),
                                  ),
                                  whiteSpaceH(10),
                                  _cafeMenuData[num].menuOptions != null
                                      ? Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                _cafeMenuData[num].menuOptions,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: Color.fromARGB(
                                                        255, 102, 102, 102)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  _cafeMenuData[num].menuOptions != null
                                      ? whiteSpaceH(10)
                                      : Container()
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: _cafeMenuData[num].menuImg != null
                          ? whiteSpaceW(10)
                          : Container(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: _cafeMenuData[num].menuImg != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 219, 219, 219),
                                        blurRadius: 7)
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    _cafeMenuData[num].menuImg,
                                    fit: BoxFit.fill,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          if (_cafeMenuData[num].popularityMenu != null) {
            if (_cafeMenuData[num].popularityMenu == true) {
              menuNum++;
              return Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  height: _cafeMenuData[num].menuOptions != null ? 90 : 70,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "${menuNum}",
                        style: TextStyle(
                            color: Color.fromARGB(255, 167, 167, 167),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      whiteSpaceW(15),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: White,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  blurRadius: 7)
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: _cafeMenuData[num].menuImg != null
                                    ? whiteSpaceW(10)
                                    : Container(),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: _cafeMenuData[num].menuImg != null
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 219, 219, 219),
                                                  blurRadius: 7)
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              _cafeMenuData[num].menuImg,
                                              fit: BoxFit.fill,
                                              width: 60,
                                              height: 60,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                              whiteSpaceW(10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex:
                                          _cafeMenuData[num].description != null
                                              ? 2
                                              : 3,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "${_cafeMenuData[num].menuName}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Black),
                                        ),
                                      ),
                                    ),
                                    _cafeMenuData[num].description != null
                                        ? Expanded(
                                            child: Text(
                                              _cafeMenuData[num].description,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 106, 106, 106),
                                                fontSize: 10,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "먹어본 사람",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 167, 167, 167),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          _cafeMenuData[num].priceType == 0
                                              ? whiteSpaceW(20)
                                              : whiteSpaceW(10),
                                          Expanded(
                                            child: Text(
                                              _cafeMenuData[num]
                                                  .atePerson
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: Black),
                                            ),
                                          ),
                                          whiteSpaceW(10),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: _cafeMenuData[num]
                                                        .priceType ==
                                                    0
                                                ? Text(
                                                    "${numberFormat.format(_cafeMenuData[num].price)}원",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255,
                                                            102,
                                                            102,
                                                            102)),
                                                  )
                                                : Row(
                                                    children: <Widget>[
                                                      ClipOval(
                                                        child: Container(
                                                          width: 10,
                                                          height: 10,
                                                          color: Color.fromARGB(
                                                              255, 224, 32, 32),
                                                        ),
                                                      ),
                                                      whiteSpaceW(3),
                                                      Text(
                                                        "${numberFormat.format(_cafeMenuData[num].hot)}원",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    102,
                                                                    102,
                                                                    102),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      whiteSpaceW(5),
                                                      ClipOval(
                                                        child: Container(
                                                          width: 10,
                                                          height: 10,
                                                          color: Color.fromARGB(
                                                              255, 0, 145, 255),
                                                        ),
                                                      ),
                                                      whiteSpaceW(3),
                                                      Text(
                                                        "${numberFormat.format(_cafeMenuData[num].ice)}원",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    102,
                                                                    102,
                                                                    102),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          whiteSpaceW(10)
                                        ],
                                      ),
                                    ),
                                    whiteSpaceH(10),
                                    _cafeMenuData[num].menuOptions != null
                                        ? Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text(
                                                  _cafeMenuData[num]
                                                      .menuOptions,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          255, 102, 102, 102)),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    _cafeMenuData[num].menuOptions != null
                                        ? whiteSpaceH(10)
                                        : Container()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return Container();
        }
        return Container();
      },
      shrinkWrap: true,
      itemCount: _cafeMenuData.length,
    );
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
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
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
                            if (selectMenu == "전체메뉴") {
                              return idx == menuNameList.length + 1
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                        );
                            }
                            return Container();
//                            return selectMenu == "전체메뉴"
//                                ?
//                                : Container(width: 0, height: 0,);
                          },
                          separatorBuilder: (context, idx) {
                            int menuNum = 0;
                            return Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: selectMenu == "전체메뉴"
                                  ? idx == 0
                                      ? listSet(idx, menuNum)
                                      : listSet(idx, menuNum)
                                  : idx != 0
                                      ? selectMenu == menuNameList[idx - 1]
                                          ? listSet(idx, menuNum)
                                          : Container()
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
