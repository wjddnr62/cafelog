class FavoriteData {
  final String auth_id;
  final String cafe_name;
  final String cafe_identify;

  FavoriteData({this.auth_id, this.cafe_name, this.cafe_identify});

  factory FavoriteData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      return FavoriteData(
          auth_id: data['auth_id'],
          cafe_name: data['cafe_name'],
          cafe_identify: data['cafe_identify']);
    }
    return null;
  }
}

class FavoriteCafeData {
  final String pic;
  final String user_num;
  final String recent_num;
  final String name;
  final String location;

  FavoriteCafeData(
      {this.pic, this.user_num, this.recent_num, this.name, this.location});

  factory FavoriteCafeData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      return FavoriteCafeData(
          pic: data['pic'],
          user_num: data['user_num'],
          recent_num: data['recent_num'],
          name: data['name'],
          location: data['location']);
    }
    return null;
  }
}
