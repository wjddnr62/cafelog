class MyAroundData {
  String url;
  String identify;
  String name;
  String subname;
  String phone;
  String addr;
  String category;
  String opentime;
  String lat;
  String lon;
  String menu;
  String homepage;
  String convenien;
  String pic;
  int user_num;
  String km;

  MyAroundData(
      {this.url,
      this.identify,
      this.name,
      this.subname,
      this.phone,
      this.addr,
      this.category,
      this.opentime,
      this.lat,
      this.lon,
      this.menu,
      this.homepage,
      this.convenien,
      this.pic,
      this.user_num, this.km});

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
          lat: data['lat'],
          lon: data['lon'],
          menu: data['menu'],
          homepage: data['homepage'],
          convenien: data['convenien'],
          pic: data['pic'],
          user_num: data['user_num']);
    }
    return null;
  }
}
