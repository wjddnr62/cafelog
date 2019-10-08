import 'package:flutter/cupertino.dart';

import '../../colors.dart';

class PopularityCafe extends StatefulWidget {
  @override
  _PopularityCafe createState() => _PopularityCafe();
}

class _PopularityCafe extends State<PopularityCafe> {
  bool filterButton = false;

  BoxDecoration selectFilterDeco =
      BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(16));
  TextStyle selectFilterStyle = TextStyle(color: White, fontSize: 12);
  TextStyle nonSelectFilterStyle =
      TextStyle(color: Color.fromARGB(255, 122, 122, 122), fontSize: 12);

  BoxDecoration tagDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color.fromARGB(255, 247, 247, 247));

  BoxDecoration tagClickDecoration =
      BoxDecoration(borderRadius: BorderRadius.circular(5), color: mainColor);

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

  int clickNum;

  bool visitCafe = false;

  tagList() => ListView.builder(
        itemCount: tagListItem.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (clickNum == position) {
                    clickNum = null;
                    // 선택해제
                  } else {
                    clickNum = position;
                    // 선택
                  }
                });
                print("태그 클릭 : " + tagListItem[position]);
              },
              child: Container(
                width: 60,
                height: 30,
                decoration:
                    clickNum == position ? tagClickDecoration : tagDecoration,
                child: Center(
                  child: Text(
                    tagListItem[position],
                    style: clickNum == position
                        ? TextStyle(fontSize: 12, color: White)
                        : TextStyle(fontSize: 12, color: Black),
                  ),
                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      );

  menuBar(content) => GestureDetector(
        onTap: () {
          if (content == "인기") {
            if (filterButton == true) {
              setState(() {
                filterButton = false;
              });
            }
          } else if (content == "최근 핫플") {
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
                    width: 70,
                    height: 30,
                    child: Center(
                      child: Text(
                        content,
                        style: selectFilterStyle,
                      ),
                    ),
                  )
                : Container(
                    width: 70,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, top: 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                menuBar("인기"),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 5),
                  child: menuBar("최근 핫플"),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, right: 15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (visitCafe) {
                              visitCafe = false;
                            } else {
                              visitCafe = true;
                            }
                          });
                        },
                        child: Container(
                          width: 90,
                          height: 30,
                          decoration: BoxDecoration(
                            color: visitCafe == false
                                ? White
                                : Color.fromARGB(255, 240, 240, 240),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              "다녀온카페 제외",
                              style: visitCafe == false
                                  ? TextStyle(
                                      color: Color.fromARGB(255, 122, 122, 122),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)
                                  : TextStyle(
                                      color: Black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
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
          ),
        ],
      ),
    );
  }
}
