import 'dart:convert';

import 'package:http/http.dart';

class MainProvider {
  Client _client = Client();
  final _baseUrl = "http://api.service.oig.kr/";
  final _autoTag = "http://api.service.oig.kr/cafe_api/api/info/tags/contains?";
  final _restUrl = "http://api.service.oig.kr/cafelog_api/api/cafe/";

//  final _instaUrl = "https://api.instagram.com/v1/users/self?access_token=";
  final _instaUrl = "https://api.instagram.com/oauth/access_token";
  final _instaSecretCode = "a0bcae4101bddb280c73d07470441cec";
  final _instaUserData = "https://graph.instagram.com/";

  Future<String> getMainList(limit, street, String type, tag) async {
    final response = await _client.get(
        "${_restUrl}cafe-list?limit=${limit == null ? 0 : limit}&street=${street == null ? "" : street}&type=${type == null ? "0" : type}&tag=${tag == null ? "" : tag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMorePicture(limit, street, String type, tag) async {
    final response = await _client.get(
        "${_restUrl}more-picture?limit=${limit == null ? 0 : limit}&tag=${tag == null ? "" : tag}");

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
    final response =
        await _client.get("${_restUrl}select-tag-history?tag=${keyword}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> setAutoTag(tag) async {
    final response =
        await _client.get("${_restUrl}insert-tag-history?tag=${tag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getStreets() async {
    final response =
        await _client.get(_baseUrl + "cafe_crawler_api/api/streets");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getPopularityCafe(location, type, streetTag) async {
    final response = await _client.get(
        "${_restUrl}popularly-street?location=${location == null ? "" : location}&type=${type == null ? "0" : type}&tag=${streetTag == null ? "" : streetTag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getCafeDetailPerson(name) async {
    print("${_restUrl}cafe-detail-person?name=${name}");
    final response =
        await _client.get("${_restUrl}cafe-detail-person?name=${name}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getCafeRecodeCount(tag) async {
    final response =
        await _client.get("${_restUrl}cafe-recode-count?tag=${tag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getTagList() async {
    // tag api 수정 후 적용.
    final response = await _client.get(_baseUrl + "cafe_api/api/info/tags");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> userAuth(
      userId, fcm, deviceName, deviceOs, userName, userPicture) async {
    final response = await _client.get(
        "${_restUrl}user-auth?id=$userId&fcm=$fcm&device_name=$deviceName&device_os=$deviceOs&user_name=$userName&user_picture=$userPicture");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> instaUserData(code) async {
    final response = await _client.post(_instaUrl, body: {
      'client_id': '635207797253863',
      'client_secret': _instaSecretCode,
      'code': code,
      'grant_type': 'authorization_code',
      'redirect_uri': 'https://localhost/'
    });

    print("check 2 ; ${utf8.decode(response.bodyBytes)}");

    print("check : " + _instaUserData + json.decode(utf8.decode(response.bodyBytes))['user_id'].toString() + "?fields=id,username&access_token=${json.decode(utf8.decode(response.bodyBytes))['access_token']}");

    final response2 = await _client.get(_instaUserData + json.decode(utf8.decode(response.bodyBytes))['user_id'].toString() + "?fields=id,username&access_token=${json.decode(utf8.decode(response.bodyBytes))['access_token']}");

    return utf8.decode(response2.bodyBytes);
  }

  Future<String> getMyAround(addr, addr2, cafe, myAroundTag) async {
    final response = await _client.get(
        "${_restUrl}my-around?addr=${addr}&addr2=${addr2 == null ? "" : addr}&cafe=${cafe == null ? "" : cafe}&tag=${myAroundTag == null ? "" : myAroundTag}");

    print(
        "responseMyAround : ${_restUrl}my-around?addr=${addr}&addr2=${addr2 == null ? "" : addr}&cafe=${cafe == null ? "" : cafe}&tag=${myAroundTag == null ? "" : myAroundTag}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getAuth(soical_id) async {
    final response =
        await _client.get("${_restUrl}get-auth?soical_id=${soical_id}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> insertFavorite(id, name, identify) async {
    final response = await _client.get(
        "${_restUrl}insert-favorite?id=${id}&name=${name}&identify=${identify}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getFavorite(id, name) async {
    final response =
        await _client.get("${_restUrl}get-favorite?id=${id}&name=${name}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> favoriteCafe(name) async {
    final response = await _client.get("${_restUrl}favorite-cafe?name=${name}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> deleteFavorite(identify) async {
    final response =
        await _client.get("${_restUrl}delete-favorite?identify=${identify}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> deleteAuth(id) async {
    final response = await _client.get("${_restUrl}delete-auth?id=${id}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> deleteAuthFavorite(id) async {
    final response =
        await _client.get("${_restUrl}delete-auth-favorite?id=${id}");

    return utf8.decode(response.bodyBytes);
  }

  Future<String> updateFcmKey(fcm, id) async {
    final response = await _client.get("${_restUrl}update-fcm-key?fcm=${fcm}&id=${id}");

    return utf8.decode(response.bodyBytes);
  }
}
