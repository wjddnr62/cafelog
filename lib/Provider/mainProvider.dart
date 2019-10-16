import 'dart:convert';

import 'package:http/http.dart';

class MainProvider {
  Client _client = Client();
  final _baseUrl = "http://api.service.oig.kr/";
  final _autoTag = "http://api.service.oig.kr/cafe_api/api/info/tags/contains?";

  Future<String> getAutoTag(keyword) async {
    final response = await _client.get(_autoTag + "keyword=${keyword}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getStreets() async {
    final response = await _client.get(_baseUrl + "cafe_crawler_api/api/streets");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getPopularityCafe(street) async {
    if (street == null || street == "" || street == "전체카페") {
      // 전체 조회 api 완성시 변경
      final response = await _client.get("${_baseUrl}cafe_crawler_api/api/streets/cafes?street=경리단길");

      return utf8.decode(response.bodyBytes);
    } else {
      final response = await _client.get("${_baseUrl}cafe_crawler_api/api/streets/cafes?street=${street}");

      return utf8.decode(response.bodyBytes);
    }
  }

  Future<String> getTagList() async {
    // tag api 수정 후 적용.
    final response = await _client.get(_baseUrl + "cafe_api/api/info/tags");

    return utf8.decode(response.bodyBytes);
  }
}
