import 'dart:async';
import 'dart:core' as prefix0;
import 'dart:core';

import 'package:cafelog/Repository/mainRepository.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc {
  final _mainRepository = MainRepository();

  // authSave
    String _authId;
    String _authName;
    String _authPicture;
    String _fcmKey;
    String _authToken;


  String get authToken => _authToken;

  set authToken(String value) {
    _authToken = value;
  }

  String get authName => _authName;

  set authName(String value) {
    _authName = value;
  }

  String get authPicture => _authPicture;

  set authPicture(String value) {
    _authPicture = value;
  }

  String get fcmKey => _fcmKey;

  set fcmKey(String value) {
    _fcmKey = value;
  }


  String get authId => _authId;

  set authId(String value) {
    _authId = value;
  } //

  List<String> _tagDefaultItem;
  List<bool> _tagClick;
  List<String> _tagSelectList;
  String _tagSave;


  String get tagSave => _tagSave;

  set tagSave(String value) {
    _tagSave = value;
  }

  get tagDefaultItem => _tagDefaultItem;

  set tagDefaultItem(value) {
    _tagDefaultItem = value;
  }

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
  final _streetTag = BehaviorSubject<String>();

  Observable<String> get street => _street.stream;
  Observable<int> get popType => _popType.stream;
  Observable<String> get streetTag => _streetTag.stream;

  Function(String) get setStreet => _street.sink.add;
  Function(int) get setPopType => _popType.sink.add;
  Function(String) get setStreetTag => _streetTag.sink.add;

  Future<String> getPopularityCafe() => _mainRepository.getPopularityCafe(_street.value, _popType.value, _streetTag.value);

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

  // userAuth(user-auth)
  final _userId = BehaviorSubject<String>();
  final _fcm = BehaviorSubject<String>();
  final _deviceName = BehaviorSubject<String>();
  final _deviceOs = BehaviorSubject<String>();
  final _userName = BehaviorSubject<String>();
  final _userPicture = BehaviorSubject<String>();

  Observable<String> get userId => _userId.stream;
  Observable<String> get fcm => _fcm.stream;
  Observable<String> get deviceName => _deviceName.stream;
  Observable<String> get deviceOs => _deviceOs.stream;
  Observable<String> get userName => _userName.stream;
  Observable<String> get userPicture => _userPicture.stream;

  Function(String) get setUserId => _userId.sink.add;
  Function(String) get setFcm => _fcm.sink.add;
  Function(String) get setDeviceName => _deviceName.sink.add;
  Function(String) get setDeviceOs => _deviceOs.sink.add;
  Function(String) get setUserName => _userName.sink.add;
  Function(String) get setUserPicture => _userPicture.sink.add;

  Future<String> userAuth() => _mainRepository.userAuth(_userId.value, _fcm.value, _deviceName.value, _deviceOs.value, _userName.value, _userPicture.value);

  // instaUserData

  final _accessToekn = BehaviorSubject<String>();

  Observable<String> get accessToken => _accessToekn.stream;

  Function(String) get setAccessToken => _accessToekn.sink.add;

  Future<String> instaUserData() => _mainRepository.instaUserData(_accessToekn.value);

  // myAround(my-around)

  final _addr = BehaviorSubject<String>();
  final _addr2 = BehaviorSubject<String>();
  final _cafe = BehaviorSubject<String>();
  final _myAroundTag = BehaviorSubject<String>();

  Observable<String> get addr => _addr.stream;
  Observable<String> get addr2 => _addr2.stream;
  Observable<String> get cafe => _cafe.stream;
  Observable<String> get myAroundTag => _myAroundTag.stream;

  Function(String) get setAddr => _addr.sink.add;
  Function(String) get setAddr2 => _addr2.sink.add;
  Function(String) get setCafe => _cafe.sink.add;
  Function(String) get setMyAroundTag => _myAroundTag.sink.add;

  Future<String> getMyAround() => _mainRepository.getMyAround(_addr.value, _addr2.value, _cafe.value, _myAroundTag.value);

  // getAuth

  final _soical_id = BehaviorSubject<String>();

  Observable<String> get soicalId => _soical_id.stream;

  Function(String) get setSoicalId => _soical_id.sink.add;

  Future<String> getAuth() => _mainRepository.getAuth(_soical_id.value);

  // insertFavorite

  final _favoriteId = BehaviorSubject<String>();
  final _favoriteName = BehaviorSubject<String>();
  final _favoriteIdentify = BehaviorSubject<String>();

  Observable<String> get favoriteId => _favoriteId.stream;
  Observable<String> get favoriteName => _favoriteName.stream;
  Observable<String> get favoriteIdentify => _favoriteIdentify.stream;

  Function(String) get setFavoriteId => _favoriteId.sink.add;
  Function(String) get setFavoriteName => _favoriteName.sink.add;
  Function(String) get setFavoriteIdentify => _favoriteIdentify.sink.add;

  Future<String> insertFavorite() => _mainRepository.insertFavorite(_favoriteId.value, _favoriteName.value, _favoriteIdentify.value);

  // getFavorite

  Future<String> getFavorite() => _mainRepository.getFavorite(_favoriteId.value, _favoriteName.value);

  // favoriteCafe

  final _nameValue = BehaviorSubject<String>();

  Observable<String> get nameValue => _nameValue.stream;

  Function(String) get setNameValue => _nameValue.sink.add;

  Future<String> favoriteCafe() => _mainRepository.favoriteCafe(_nameValue.value);

  // deleteFavorite

  Future<String> deleteFavorite() => _mainRepository.deleteFavorite(_favoriteIdentify.value);

  // deleteAuth

  Future<String> deleteAuth() => _mainRepository.deleteAuth(_favoriteId.value);

  // deleteAuthFavorite

  Future<String> deleteAuthFavorite() => _mainRepository.deleteAuthFavorite(_favoriteId.value);

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
    _userId.close();
    _fcm.close();
    _deviceName.close();
    _deviceOs.close();
    _recodeTag.close();
    _insertTag.close();
    _detailName.close();
    _accessToekn.close();
  }

  get tagClick => _tagClick;

  set tagClick(value) {
    _tagClick = value;
  }

  get tagSelectList => _tagSelectList;

  set tagSelectList(value) {
    _tagSelectList = value;
  }


}


final mainBloc = MainBloc();