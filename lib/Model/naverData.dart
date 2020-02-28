class NaverData {
  final String url;
  final String identify;
  final String name;
  final String category;
  final String subname;
  final String phone;
  final String addr;
  final String opentime;
  final String lat;
  final String lon;
  final String menu;
  final String homepage;
  final String convenien;
  final String description;

  NaverData({this.url, this.identify, this.name, this.category, this.subname, this.phone, this.addr, this.opentime, this.lat, this.lon, this.menu, this.homepage, this.convenien, this.description});

  factory NaverData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      if (data['data'] != null) {
        return NaverData(
          url: data['url'],
          identify: data['identify'],
          name: data['name'],
          category: data['category'],
          subname: data['subname'],
          phone: data['phone'],
          addr: data['addr'],
          opentime: data['opentime'],
          lat: data['lat'],
          lon: data['lon'],
          menu: data['menu'],
          homepage: data['homepage'],
          convenien: data['convenien'],
          description: data['description']
        );
      }
    }
    return null;
  }
}