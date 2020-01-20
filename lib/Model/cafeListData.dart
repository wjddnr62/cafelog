class CafeListData {
  final String url;
  final String nickname;
  final String pic;
  final String date;
  final int like;
  final String search_tag;

  CafeListData({this.url, this.nickname, this.pic, this.date, this.like, this.search_tag});

  factory CafeListData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      if (data.length != 0) {
        return CafeListData(
          url: data['url'],
          nickname: data['nickname'],
          pic: data['pic'],
          date: data['date'],
          like: data['like'],
          search_tag: data['search_tag']
        );
      }
    }
    return null;
  }

}