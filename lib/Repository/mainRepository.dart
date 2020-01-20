import 'package:cafelog/Provider/mainProvider.dart';

class MainRepository {
  final _mainProvier = MainProvider();

  Future<String> getMainList(limit, street, type, tag) => _mainProvier.getMainList(limit, street, type, tag);

  Future<String> getMorePicture(limit, street, type, tag) => _mainProvier.getMorePicture(limit, street, type, tag);

  Future<String> getNaverData(name) => _mainProvier.getNaverData(name);

  Future<String> getPopularPic(name) => _mainProvier.getPopularPic(name);

  Future<String> getTagList() => _mainProvier.getTagList();

  Future<String> getStreets() => _mainProvier.getStreets();

  Future<String> getPopularityCafe(location, type) => _mainProvier.getPopularityCafe(location, type);

  Future<String> getCafeDetailPerson(name) => _mainProvier.getCafeDetailPerson(name);

  Future<String> getAutoTag(keyword) => _mainProvier.getAutoTag(keyword);

  Future<String> getCafeRecodeCount(tag) => _mainProvier.getCafeRecodeCount(tag);

  Future<String> setAutoTag(tag) => _mainProvier.setAutoTag(tag);
}
