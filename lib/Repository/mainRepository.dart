import 'package:cafelog/Provider/mainProvider.dart';

class MainRepository {
  final _mainProvier = MainProvider();

  Future<String> getMainList(limit, street, type, tag) => _mainProvier.getMainList(limit, street, type, tag);

  Future<String> getMorePicture(limit, street, type, tag) => _mainProvier.getMorePicture(limit, street, type, tag);

  Future<String> getNaverData(name) => _mainProvier.getNaverData(name);

  Future<String> getPopularPic(name) => _mainProvier.getPopularPic(name);

  Future<String> getTagList() => _mainProvier.getTagList();

  Future<String> getStreets() => _mainProvier.getStreets();

  Future<String> getPopularityCafe(location, type, streetTag) => _mainProvier.getPopularityCafe(location, type, streetTag);

  Future<String> getCafeDetailPerson(name) => _mainProvier.getCafeDetailPerson(name);

  Future<String> getAutoTag(keyword) => _mainProvier.getAutoTag(keyword);

  Future<String> getCafeRecodeCount(tag) => _mainProvier.getCafeRecodeCount(tag);

  Future<String> setAutoTag(tag) => _mainProvier.setAutoTag(tag);

  Future<String> userAuth(userId, fcm, deviceName, deviceOs, userName, userPicture) => _mainProvier.userAuth(userId, fcm, deviceName, deviceOs, userName, userPicture);

  Future<String> instaUserData(code) => _mainProvier.instaUserData(code);

  Future<String> getMyAround(addr, addr2, cafe, myAroundTag) => _mainProvier.getMyAround(addr, addr2, cafe, myAroundTag);

  Future<String> getAuth(soical_id) => _mainProvier.getAuth(soical_id);

  Future<String> insertFavorite(id, name, identify) => _mainProvier.insertFavorite(id, name, identify);

  Future<String> getFavorite(id, name) => _mainProvier.getFavorite(id, name);

  Future<String> favoriteCafe(name) => _mainProvier.favoriteCafe(name);

  Future<String> deleteFavorite(identify) => _mainProvier.deleteFavorite(identify);

  Future<String> deleteAuth(id) => _mainProvier.deleteAuth(id);

  Future<String> deleteAuthFavorite(id) => _mainProvier.deleteAuthFavorite(id);

  Future<String> updateFcmKey(fcm, id) => _mainProvier.updateFcmKey(fcm, id);
}
