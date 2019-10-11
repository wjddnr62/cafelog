class AutoTag {
  final int result;
  final int id;
  final String name;

  AutoTag({this.result, this.id, this.name});

  factory AutoTag.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      return AutoTag(
        id: data['id'],
        name: data['name']
      );
    }
    return null;
  }
}