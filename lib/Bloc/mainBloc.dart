import 'package:cafelog/Repository/mainRepository.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc {
  final _mainRepository = MainRepository();

  final _keyword = BehaviorSubject<String>();
  final _street = BehaviorSubject<String>();

  Observable<String> get keyword => _keyword.stream;
  Observable<String> get street => _street.stream;

  Function(String) get setKeyword => _keyword.sink.add;
  Function(String) get setStreet => _street.sink.add;

  Future<String> getTagList() => _mainRepository.getTagList();

  Stream<String> getStreets() => Stream.fromFuture(_mainRepository.getStreets());

  Stream<String> getPopularityCafe() => Stream.fromFuture(_mainRepository.getPopularityCafe(_street.value));

  Stream<String> getAutoTag() => Stream.fromFuture(_mainRepository.getAutoTag(_keyword.value));

  dispose() {
    _keyword.close();
    _street.close();
  }


}


final mainBloc = MainBloc();