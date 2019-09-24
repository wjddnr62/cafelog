import 'package:cafelog/Model/instaPostData.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  bool filterButton = false;

  BoxDecoration selectFilterDeco =
      BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(16));
  TextStyle selectFilterStyle = TextStyle(color: White, fontSize: 12);
  TextStyle nonSelectFilterStyle =
      TextStyle(color: Color.fromARGB(255, 122, 122, 122), fontSize: 12);

  List<String> tagListItem = [
    "#마카롱",
    "#흑당라떼",
    "#케이크",
    "#베이커리",
    "#레스토랑",
    "#테스트",
    "#테스트2",
    "#테스트3",
    "#테스트4",
    "#테스트5",
    "#테스트6",
    "#테스트7"
  ];

  List<InstaPostData> instaPostLeftData = [];
  List<InstaPostData> instaPostRightData = [];

  BoxDecoration tagDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color.fromARGB(255, 247, 247, 247));

  PanelController _panelController = PanelController();

  int upPanelMenuType = 0; // 0 == 홈, 1 == 인기카페, 2 == 내 주변, 3 == 로그인

  final upPanelColor = const Color.fromARGB(255, 219, 219, 219);
  final mainUpPanelText =
      TextStyle(fontSize: 14.0, color: Black, fontWeight: FontWeight.bold);
  final mainUpPanelHoverText =
      TextStyle(fontSize: 14.0, color: mainColor, fontWeight: FontWeight.bold);
  final instaPostDataNameText = TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: White, shadows: [
    Shadow(
      color: Black, blurRadius: 5
    )
  ]);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      List<String> image = List();
      if (i >= 0 && i < 5) {
        if (i == 2) {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          image.add("assets/test/test${i + 2}.png");
          instaPostLeftData.add(InstaPostData(image, "@test${i}"));
        } else {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          instaPostLeftData.add(InstaPostData(image, "@test${i}"));
        }
      } else {
        if (i == 7) {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          image.add("assets/test/test${i + 2}.png");
          instaPostRightData.add(InstaPostData(image, "@test${i}"));
        } else {
          image.clear();
          image.add("assets/test/test${i + 1}.png");
          instaPostRightData.add(InstaPostData(image, "@test${i}"));
        }
      }
    }
    print(instaPostLeftData.length.toString() + ", " + instaPostRightData.length.toString());
  }

  homeAppBar() => AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: White,
        title: GestureDetector(
          onTap: () {
            print("카페 지역 선택");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "전체카페",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Black),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: mainColor,
                size: 18,
              )
            ],
          ),
        ),
        // bloc 에 카페명 저장하여 관리
        leading: IconButton(
          onPressed: () {
            print("검색");
          },
          icon: Icon(
            Icons.search,
            color: Color.fromARGB(255, 122, 122, 122),
            size: 30,
          ),
        ),
        actions: <Widget>[whiteSpaceW(MediaQuery.of(context).size.width / 5)],
      );

  tagList() => ListView.builder(
        itemCount: tagListItem.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                print("태그 클릭 : " + tagListItem[position]);
              },
              child: Container(
                width: 60,
                height: 30,
                decoration: tagDecoration,
                child: Center(
                  child: Text(
                    tagListItem[position],
                    style: TextStyle(fontSize: 12, color: Black),
                  ),
                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      );

  upPanelMenu(menuType, menuName) => menuType == 3
      ? Expanded(
          flex: 2,
          child: upPanelMenuType == menuType
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      upPanelMenuType = menuType;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20 / 2),
                          child: Text(
                            menuName,
                            style: mainUpPanelHoverText,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.brightness_1,
                            size: 5,
                            color: mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      upPanelMenuType = menuType;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20 / 2),
                            child: Text(
                              menuName,
                              style: mainUpPanelText,
                            ),
                          ),
                        ),
                        whiteSpaceH(10)
                      ],
                    ),
                  ),
                ),
        )
      : Expanded(
          child: upPanelMenuType == menuType
              ? Container(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        upPanelMenuType = menuType;
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20 / 2),
                            child: Text(
                              menuName,
                              style: mainUpPanelHoverText,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.brightness_1,
                              size: 5,
                              color: mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      upPanelMenuType = menuType;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20 / 2),
                            child: Text(
                              menuName,
                              style: mainUpPanelText,
                            ),
                          ),
                        ),
                        whiteSpaceH(10)
                      ],
                    ),
                  ),
                ),
        );

  slidingUpPanelBody() => SlidingUpPanel(
        controller: _panelController,
        minHeight: 60,
        maxHeight: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height / 6),
        isDraggable: false,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
        border: Border.all(color: upPanelColor, width: 0.1),
        backdropEnabled: false,
        parallaxEnabled: false,
        boxShadow: [BoxShadow(color: Colors.transparent)],
        panel: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        collapsed: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(top: 5.0),
//                child: Container(
//                  width: 50,
//                  height: 5,
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(16.0),
//                    color: Color.fromARGB(255, 216, 216, 216),
//                  ),
//                ),
//              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  children: <Widget>[
                    upPanelMenu(0, "홈"),
                    upPanelMenu(1, "인기카페"),
                    upPanelMenu(2, "내 주변"),
                    upPanelMenu(3, "로그인")
                  ],
                ),
              )
            ],
          ),
        ),
        body: body(),
      );

  menuBar(content) => GestureDetector(
        onTap: () {
          if (content == "인기") {
            if (filterButton == true) {
              setState(() {
                filterButton = false;
              });
            }
          } else if (content == "최신") {
            if (filterButton == false) {
              setState(() {
                filterButton = true;
              });
            }
          }
        },
        child: content == "인기"
            ? filterButton == false
                ? Container(
                    decoration: selectFilterDeco,
                    width: 50,
                    height: 30,
                    child: Center(
                      child: Text(
                        content,
                        style: selectFilterStyle,
                      ),
                    ),
                  )
                : Container(
                    width: 50,
                    height: 30,
                    color: White,
                    child: Center(
                      child: Text(
                        content,
                        style: nonSelectFilterStyle,
                      ),
                    ),
                  )
            : filterButton == true
                ? Container(
                    decoration: selectFilterDeco,
                    width: 50,
                    height: 30,
                    child: Center(
                      child: Text(
                        content,
                        style: selectFilterStyle,
                      ),
                    ),
                  )
                : Container(
                    width: 50,
                    height: 30,
                    color: White,
                    child: Center(
                      child: Text(
                        content,
                        style: nonSelectFilterStyle,
                      ),
                    ),
                  ),
      );

  instaCafePost() => Padding(
        padding: EdgeInsets.only(top: 20, bottom: 150, left: 15, right: 15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: instaPostLeftData.length,
                  itemBuilder: (context, position) {
                    if (instaPostLeftData.length != position) {
                      return GestureDetector(
                        onTap: (){
                          print("left");
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset(
                                  instaPostLeftData[position].img[0],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(child: Text(instaPostLeftData[position].instaName, style: instaPostDataNameText,), bottom: 15, left: 5,),
                            instaPostLeftData[position].img.length == 2 ? Positioned(
                              child: Icon(Icons.photo_library, color: White, size: 14,), right: 5, bottom: 15,
                            ) : Container()
                          ],
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              whiteSpaceW(15),
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: instaPostRightData.length,
                  itemBuilder: (context, position) {
                    if (instaPostLeftData.length != position) {
                      return GestureDetector(
                        onTap: (){
                          print("right");
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset(
                                  instaPostRightData[position].img[0],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(child: Text(instaPostRightData[position].instaName, style: instaPostDataNameText,), bottom: 15, left: 5,),
                            instaPostRightData[position].img.length == 2 ? Positioned(
                              child: Icon(Icons.photo_library, color: White, size: 14,), right: 5, bottom: 15,
                            ) : Container()
                          ],
                        ),
                      );
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
      );

  body() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  menuBar("인기"),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: menuBar("최신"),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 10, right: 10),
              child: Container(
                height: 30,
                child: tagList(),
              ),
            ),
            whiteSpaceH(10),
            instaCafePost()
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: homeAppBar(),
      backgroundColor: White,
      resizeToAvoidBottomInset: true,
      body: slidingUpPanelBody(),
    );
  }
}
