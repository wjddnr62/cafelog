/*
route file
 */

import 'package:cafelog/Screens/CafeLocationSearch/locationSearch.dart';
import 'package:cafelog/Screens/PopularityCafe/cafeDetail.dart';
import 'package:cafelog/Screens/PopularityCafe/naverCafeInfo.dart';
import 'package:cafelog/Screens/PopularityCafe/storeDetail.dart';

import 'Screens/Home/home.dart';
import 'Screens/Login/instaLogin.dart';
import 'Screens/Login/loginMain.dart';
import 'Screens/PopularityCafe/cafeLocation.dart';
import 'Screens/PopularityCafe/cafeMenu.dart';
import 'Screens/splash.dart';

final routes = {
  '/': (context) => Splash(),
  '/LoginMain': (context) => LoginMain(),
  '/InstaLogin': (context) => InstaLogin(),
  '/Home': (context) => Home(),
  '/LocationSearch': (context) => LocationSearch(),
  '/CafeDetail': (context) => CafeDetail(),
  '/CafeLocation': (context) => CafeLocation(),
  '/StoreDetail': (context) => StoreDetail(),
  '/NaverCafeInfo': (context) => NaverCafeInfo(),
  '/CafeMenu': (context) => CafeMenu(),
};
