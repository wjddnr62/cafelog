class CafeMenuData {
  String menuImg;
  String menuName;
  String menuType;
  int atePerson;
  int price;
  int hot;
  int ice;
  int priceType; // 0 = 통합, 1 = 핫 아이스 각각
  String description;
  String menuOptions;
  bool popularityMenu = false; // 5개 까지만 true 가 됨

  CafeMenuData({this.menuImg,
    this.menuName,
    this.menuType,
    this.atePerson,
    this.price,
    this.hot,
    this.ice,
    this.priceType,
    this.description,
    this.menuOptions,
    this.popularityMenu});
}
