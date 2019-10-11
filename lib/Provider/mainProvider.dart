import 'dart:convert';

import 'package:http/http.dart';

class MainProvider {
  Client _client = Client();
  final _baseUrl = "http://api.service.oig.kr/cafe_api/";
  final _autoTag = "http://api.service.oig.kr/cafe_api/api/info/tags/contains?";

  Future<String> getAutoTag(keyword) async {
    final response = await _client.get(_autoTag + "keyword=${keyword}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getTagList() async {
    // tag api 수정 후 적용.
    final response = await _client.get(_baseUrl + "api/info/tags");

    return utf8.decode(response.bodyBytes);
  }
}
