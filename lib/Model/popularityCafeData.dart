class PopularityCafeData {
  final int result;
  final String picture;
  final String name;
  final int userNum;
  final int recentNum;
  final String category;

  PopularityCafeData({this.result, this.picture, this.name, this.userNum, this.recentNum, this.category});

  factory PopularityCafeData.fromJson(Map<dynamic, dynamic> map) {
    if (map['result'] == 1) {
      return PopularityCafeData(
        picture: map['picture'],
        name: map['name'],
        userNum: map['user_num'],
        recentNum: map['recent_num'],
        category: map['category']
      );
    } else {
      return null;
    }
  }
}