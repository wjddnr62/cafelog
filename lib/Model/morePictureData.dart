class MorePictureData {
  List<String> _img;
  String _instaName;
  String _instaLink;
  int _type; // 0 = 업체사진, 1 = 매장사진, 2 = 메뉴사진, 3 = 카페에서

  MorePictureData(this._img, this._instaName, this._instaLink, this._type);

  List<String> get img => _img;

  set img(List<String> value) {
    _img = value;
  }

  String get instaName => _instaName;

  set instaName(String value) {
    _instaName = value;
  }

  String get instaLink => _instaLink;

  set instaLink(String value) {
    _instaLink = value;
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }


// 및 여러 데이터 추가
}