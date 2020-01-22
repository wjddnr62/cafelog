/*
route file
 */

import 'package:cafelog/Screens/CafeLocationSearch/locationSearch.dart';
import 'package:cafelog/Screens/Home/withdrawal.dart';
import 'package:cafelog/Screens/PopularityCafe/cafeDetail.dart';
import 'package:cafelog/Screens/PopularityCafe/morePicture.dart';
import 'package:cafelog/Screens/PopularityCafe/naverCafeInfo.dart';
import 'package:cafelog/Screens/PopularityCafe/storeDetail.dart';

import 'Screens/Home/home.dart';
import 'Screens/Home/settings.dart';
import 'Screens/Login/instaLogin.dart';
import 'Screens/Login/loginMain.dart';
import 'Screens/MyAround/myAroundMap.dart';
import 'Screens/MyCafeLog/myCafeLog.dart';
import 'Screens/PopularityCafe/cafeLocation.dart';
import 'Screens/PopularityCafe/cafeMenu.dart';
import 'Screens/splash.dart';

final routes = {
  '/Splash': (context) => Splash(),
  '/LoginMain': (context) => LoginMain(),
  '/InstaLogin': (context) => InstaLogin(),
  '/Home': (context) => Home(),
  '/LocationSearch': (context) => LocationSearch(),
  '/CafeDetail': (context) => CafeDetail(),
  '/CafeLocation': (context) => CafeLocation(),
  '/StoreDetail': (context) => StoreDetail(),
  '/NaverCafeInfo': (context) => NaverCafeInfo(),
  '/CafeMenu': (context) => CafeMenu(),
  '/MorePicture': (context) => MorePicture(),
  '/MyAroundMap': (context) => MyAroundMap(),
  '/MyCafeLog': (context) => MyCafeLog(),
  '/Setting': (context) => Setting(),
  '/Withdrawal': (context) => Withdrawal()
};
