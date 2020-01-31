class MyAroundData {
  String url;
  String identify;
  String name;
  String subname;
  String phone;
  String addr;
  String category;
  String opentime;
  String menu;
  String homepage;
  String convenien;
  String pic;
  int user_num;

  MyAroundData(
      {this.url,
      this.identify,
      this.name,
      this.subname,
      this.phone,
      this.addr,
      this.category,
      this.opentime,
      this.menu,
      this.homepage,
      this.convenien,
      this.pic,
      this.user_num});

  factory MyAroundData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      return MyAroundData(
          url: data['url'],
          identify: data['identify'],
          name: data['name'],
          subname: data['subname'],
          phone: data['phone'],
          addr: data['addr'],
          category: data['category'],
          opentime: data['opentime'],
          menu: data['menu'],
          homepage: data['homepage'],
          convenien: data['convenien'],
          pic: data['pic'],
          user_num: data['user_num']);
    }
    return null;
  }
}
