class InstaPostData {
  List<String> _img;
  String _instaName;

  InstaPostData(this._img, this._instaName);

  List<String> get img => _img;

  set img(List<String> value) {
    _img = value;
  }

  String get instaName => _instaName;

  set instaName(String value) {
    _instaName = value;
  }

// 및 여러 데이터 추가
}