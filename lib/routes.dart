/*
route file
 */



import 'Screens/Login/instaLogin.dart';
import 'Screens/Login/loginMain.dart';
import 'Screens/splash.dart';

final routes = {
  '/': (context) => Splash(),
  '/LoginMain' :(context) => LoginMain(),
  '/InstaLogin':(context) => InstaLogin()
};