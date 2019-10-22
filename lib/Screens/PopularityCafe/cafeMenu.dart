import 'package:cafelog/Model/CafeMenuData.dart';
import 'package:flutter/material.dart';

class CafeMenu extends StatefulWidget {
  @override
  _CafeMenu createState() => _CafeMenu();
}

class _CafeMenu extends State<CafeMenu> {
  List<CafeMenuData> _cafeMenuData = List();

  @override
  void initState() {
    super.initState();

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
            price: 6000
          ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
