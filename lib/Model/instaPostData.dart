class InstaPostData {
  List<String> _img;
  String _instaName;
  String _instaLink;

  InstaPostData(this._img, this._instaName, this._instaLink);

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


// 및 여러 데이터 추가
}