class CategoryData {
  String ca_category;
  String ca_name;

  CategoryData({this.ca_category, this.ca_name});

  factory CategoryData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      if (data.length != 0) {
        return CategoryData(
          ca_category: data['ca_category'],
          ca_name: data['ca_name']
        );
      }
    }
    return null;
  }
}