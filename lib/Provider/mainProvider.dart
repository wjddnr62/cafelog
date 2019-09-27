import 'dart:convert';

import 'package:http/http.dart';

class MainProvider {
  Client _client = Client();
  final _baseUrl = "http://api.service.oig.kr/cafe_api/";

  Future<String> getTagList() async {
    // tag api 수정 후 적용.
    final response = await _client.get(_baseUrl + "api/info/tags");

    return utf8.decode(response.bodyBytes);
  }
}
