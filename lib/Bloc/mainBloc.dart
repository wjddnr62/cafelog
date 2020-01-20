import 'dart:async';
import 'dart:core' as prefix0;
import 'dart:core';

import 'package:cafelog/Repository/mainRepository.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc {
  final _mainRepository = MainRepository();

  final _keyword = BehaviorSubject<String>();


  // mainList(cafe-list)
  final _limit = BehaviorSubject<int>();
  final _mainStreet = BehaviorSubject<String>();
  final _type = BehaviorSubject<String>();
  final _tag = BehaviorSubject<String>();

  Observable<int> get limit => _limit.stream;
  Observable<String> get mainStreet => _mainStreet.stream;
  Observable<String> get type => _type.stream;
  Observable<String> get tag => _tag.stream;

  Function(int) get setLimit => _limit.sink.add;
  Function(String) get setMainStreet => _mainStreet.sink.add;
  Function(String) get setType => _type.sink.add;
  Function(String) get setTag => _tag.sink.add;

  Future<String> getMainList() => _mainRepository.getMainList(_limit.value, _mainStreet.value, _type.value, _tag.value);

  Future<String> getMorePicture() => _mainRepository.getMorePicture(_limit.value, _mainStreet.value, _type.value, _tag.value);

  // naverData(naver-data)
  final _name = BehaviorSubject<String>();

  Observable<String> get name => _name.stream;

  Function(String) get setName => _name.sink.add;

  Future<String> getNaverData() => _mainRepository.getNaverData(_name.value);

  // popularPic(popular-pic)
  Future<String> getPopularPic() => _mainRepository.getPopularPic(_name.value);

  // popularlyStreet(popularly-street)
  final _street = BehaviorSubject<String>();
  final _popType = BehaviorSubject<int>();

  Observable<String> get street => _street.stream;
  Observable<int> get popType => _popType.stream;

  Function(String) get setStreet => _street.sink.add;
  Function(int) get setPopType => _popType.sink.add;

  Future<String> getPopularityCafe() => _mainRepository.getPopularityCafe(_street.value, _popType.value);

  // insertTagHistory(insert-tag-history)
  final _insertTag = BehaviorSubject<String>();

  Observable<String> get inserTag => _insertTag.stream;

  Function(String) get setInsertTag => _insertTag.sink.add;

  Future<String> setAutoTag() => _mainRepository.setAutoTag(_insertTag.value);

  // cafeDetailPerson(cafe-detail-person)
  final _detailName = BehaviorSubject<String>();

  Observable<String> get detailName => _detailName.stream;

  Function(String) get setDetailName => _detailName.sink.add;

  Future<String> getCafeDetailPerson() => _mainRepository.getCafeDetailPerson(_detailName.value);

  // cafeRecodeCount(cafe-recode-count)
  final _recodeTag = BehaviorSubject<String>();

  Observable<String> get recodeTag => _recodeTag.stream;

  Function(String) get setRecodeTag => _recodeTag.sink.add;

  Future<String> getCafeRecodeCount() => _mainRepository.getCafeRecodeCount(_recodeTag.value);

  //

  Observable<String> get keyword => _keyword.stream;

  Function(String) get setKeyword => _keyword.sink.add;

  Future<String> getTagList() => _mainRepository.getTagList();

  Stream<String> getStreets() => Stream.fromFuture(_mainRepository.getStreets());

  Stream<String> getAutoTag() => Stream.fromFuture(_mainRepository.getAutoTag(_keyword.value));

  dispose() {
    _keyword.close();
    _street.close();
    _limit.close();
    _mainStreet.close();
    _tag.close();
    _type.close();
    _name.close();
    _popType.close();
  }


}


final mainBloc = MainBloc();