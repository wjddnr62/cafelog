import 'package:cafelog/Repository/mainRepository.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc {
  final _mainRepository = MainRepository();

  final _keyword = BehaviorSubject<String>();

  Observable<String> get keyword => _keyword.stream;

  Function(String) get getKeyword => _keyword.sink.add;

  Future<String> getTagList() => _mainRepository.getTagList();

  Stream<String> getAutoTag() => Stream.fromFuture(_mainRepository.getAutoTag(_keyword.value));

  dispose() {
    _keyword.close();
  }
}


final mainBloc = MainBloc();