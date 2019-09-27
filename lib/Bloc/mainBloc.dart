import 'package:cafelog/Repository/mainRepository.dart';

class MainBloc {
  final _mainRepository = MainRepository();

  Future<String> getTagList() => _mainRepository.getTagList();
}

final mainBloc = MainBloc();