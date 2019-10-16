class StreetsData {
  final int result;
  final int cafe_num;
  final int user_num;
  final String location;
  final String picture;

  StreetsData({this.result, this.cafe_num, this.user_num, this.location, this.picture});

  factory StreetsData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      return StreetsData(
        cafe_num: data['cafe_num'],
        user_num: data['user_num'],
        location: data['location'],
        picture: data['picture']
      );
    }
    return null;
  }
}