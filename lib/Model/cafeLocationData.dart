class CafeLocationData {
  final image;
  final cafe_num;
  final user_num;
  final location;

  CafeLocationData({this.image, this.cafe_num, this.user_num, this.location});

  factory CafeLocationData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      if (data.length != 0) {
        return CafeLocationData(
          image: data['image'],
          cafe_num: data['cafe_num'],
          user_num: data['user_num'],
          location: data['location']
        );
      }
    }
    return null;
  }
}