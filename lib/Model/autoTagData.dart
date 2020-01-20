class AutoTag {
  final String tag;

  AutoTag({this.tag});

  factory AutoTag.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      return AutoTag(
        tag: data['tag']
      );
    }
    return null;
  }
}