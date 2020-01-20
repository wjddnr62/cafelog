import 'dart:convert';

import 'package:http/http.dart';

class MainProvider {
  Client _client = Client();
  final _baseUrl = "http://api.service.oig.kr/";
  final _autoTag = "http://api.service.oig.kr/cafe_api/api/info/tags/contains?";
  final _restUrl = "http://api.service.oig.kr/cafelog_api/api/cafe/";

  Future<String> getMainList(limit, street, String type, tag) async {
    final response = await _client.get("${_restUrl}cafe-list?limit=${limit == null ? 0 : limit}&street=${street == null ? "" : street}&type=${type == null ? "0" : type}&tag=${tag == null ? "" : tag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMorePicture(limit, street, String type, tag) async {
    final response = await _client.get("${_restUrl}more-picture?limit=${limit == null ? 0 : limit}&tag=${tag == null ? "" : tag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getNaverData(name) async {
    final response = await _client.get("${_restUrl}naver-data?name=${name}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getPopularPic(name) async {
    final response = await _client.get("${_restUrl}popular-pic?name=${name}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getAutoTag(keyword) async {
    final response = await _client.get("${_restUrl}select-tag-history?tag=${keyword}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> setAutoTag(tag) async {
    final response = await _client.get("${_restUrl}insert-tag-history?tag=${tag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getStreets() async {
    final response = await _client.get(_baseUrl + "cafe_crawler_api/api/streets");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getPopularityCafe(location, type) async {
      final response = await _client.get("${_restUrl}popularly-street?location=${location == null ? "" : location}&type=${type == null ? "0" : type}");

      return utf8.decode(response.bodyBytes);

  }

  Future<String> getCafeDetailPerson(name) async {
    print("${_restUrl}cafe-detail-person?name=${name}");
    final response = await _client.get("${_restUrl}cafe-detail-person?name=${name}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getCafeRecodeCount(tag) async {
    final response = await _client.get("${_restUrl}cafe-recode-count?tag=${tag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getTagList() async {
    // tag api 수정 후 적용.
    final response = await _client.get(_baseUrl + "cafe_api/api/info/tags");

    return utf8.decode(response.bodyBytes);
  }
}
