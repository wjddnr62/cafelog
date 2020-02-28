class CafeGoogleData {
  final idx;
  final search_item;
  final keyword;
  final cafe_name;
  final title;
  final url;
  final image;
  final thumbnail;
  final location;

  CafeGoogleData({this.idx, this.search_item, this.keyword, this.cafe_name, this.title, this.url, this.image, this.thumbnail, this.location});

  factory CafeGoogleData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      if (data.length != 0) {
        return CafeGoogleData(
          idx: data['idx'],
          search_item: data['search_item'],
          keyword: data['keyword'],
          cafe_name: data['cafe_name'],
          title: data['title'],
          url: data['url'],
          image: data['image'],
          thumbnail: data['thumbnail'],
          location: data['location']
        );
      }
    }
    return null;
  }
}