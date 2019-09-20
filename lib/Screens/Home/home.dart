import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';

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

  BoxDecoration tagDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Color.fromARGB(255, 247, 247, 247)
  );

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
              onTap: (){
                print("태그 클릭 : " + tagListItem[position]);
              },
              child: Container(
                width: 60,
                height: 30,
                decoration: tagDecoration,
                child: Center(
                  child: Text(tagListItem[position], style: TextStyle(fontSize: 12, color: Black),),
                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      );



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: homeAppBar(),
      backgroundColor: White,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (filterButton == true) {
                        setState(() {
                          filterButton = false;
                        });
                      }
                    },
                    child: filterButton == false
                        ? Container(
                            decoration: selectFilterDeco,
                            width: 50,
                            height: 30,
                            child: Center(
                              child: Text(
                                "인기",
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
                                "인기",
                                style: nonSelectFilterStyle,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: () {
                        if (filterButton == false) {
                          setState(() {
                            filterButton = true;
                          });
                        }
                      },
                      child: filterButton == true
                          ? Container(
                              decoration: selectFilterDeco,
                              width: 50,
                              height: 30,
                              child: Center(
                                child: Text(
                                  "최신",
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
                                  "최신",
                                  style: nonSelectFilterStyle,
                                ),
                              ),
                            ),
                    ),
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
            )
          ],
        ),
      ),
    );
  }
}
