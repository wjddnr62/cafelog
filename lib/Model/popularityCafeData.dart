class PopularityCafeData {
  final String picture;
  final String name;
  final int userNum;
  final int recentNum;

  PopularityCafeData({this.picture, this.name, this.userNum, this.recentNum});

  factory PopularityCafeData.fromJson(Map<dynamic, dynamic> map) {
    if (map['result'] == 1) {
      return PopularityCafeData(
        picture: map['picture'],
        name: map['name'],
        userNum: map['user_num'],
        recentNum: map['recent_num']
      );
    } else {
      return null;
    }
  }
}