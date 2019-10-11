import 'package:cafelog/Provider/mainProvider.dart';

class MainRepository {
  final _mainProvier = MainProvider();

  Future<String> getTagList() => _mainProvier.getTagList();

  Future<String> getAutoTag(keyword) => _mainProvier.getAutoTag(keyword);
}
