import 'dart:convert';
import 'dart:io';

import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Model/AuthData.dart';
import 'package:cafelog/Widgets/snackbar.dart';
import 'package:cafelog/colors.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstaLogin extends StatefulWidget {
  @override
  _InstaLogin createState() => _InstaLogin();
}

class _InstaLogin extends State<InstaLogin> {
  String redirectUrl = "https://localhost/";
  String testClientId = "635207797253863";

  String instaLoginUrl;
  String loadCompleteUrl;

  bool firstLoad = false;

  WebViewController _webViewController;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    sharedInit();

//    instaLoginUrl =
//        'https://api.instagram.com/oauth/authorize/?client_id=${testClientId}&redirect_uri=${redirectUrl}&response_type=code';
    instaLoginUrl =
        'https://www.instagram.com/oauth/authorize?client_id=${testClientId}&redirect_uri=${redirectUrl}&scope=user_profile&response_type=code';
  }

  sharedInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  sharedSave(accessToken, name, picture, key) async {
    await sharedPreferences.setString("userId", accessToken);
    await sharedPreferences.setString("name", name);
    await sharedPreferences.setString("picture", picture);
    await sharedPreferences.setString("key", key);
  }

  instaAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: White,
          elevation: 0.0,
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: White,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "취소",
                      style: TextStyle(
                          fontSize: 14,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  bool redirect = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () {
          if (loadCompleteUrl == null) {
            Navigator.of(context).pop();
          } else {
            _webViewController.currentUrl().then((value) {
              if (value != loadCompleteUrl) {
                _webViewController.goBack();
              } else {
                Navigator.of(context).pop();
              }
            });
          }
          return null;
        },
        child: Scaffold(
          backgroundColor: White,
          appBar: instaAppBar(),
          resizeToAvoidBottomInset: true,
          body: !redirect
              ? WebView(
                  initialUrl: instaLoginUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (_webController) {
                    _webController.clearCache();
                    _webViewController = _webController;
                  },
                  onPageFinished: (url) async {
                    if (firstLoad == false) {
                      loadCompleteUrl = url;
                      firstLoad = true;
                    }

                    if (url.contains('localhost/?')) {
                      setState(() {
                        redirect = true;
                      });
                      List<String> code = url.split("=");
                      for (int i = 0; i < code.length; i++) {
                        print("code : ${code[i]}");
                      }

                      mainBloc.setAccessToken(code[1].substring(0, code[1].length - 2));

                      String user_name;
                      String user_id;
//                      String user_picture;

                      mainBloc.instaUserData().then((value) async {
                        user_id = json.decode(value)['id'];
                        user_name = json.decode(value)['username'];
//                        user_picture =
//                            json.decode(value)['data']['profile_picture'];

                        if (Platform.isAndroid) {
                          androidDeviceInfo =
                              await deviceInfoPlugin.androidInfo;
                          print(
                              "deviceInfo : ${androidDeviceInfo.version.release}, ${androidDeviceInfo.model}");

                          mainBloc.setUserId(user_id);
                          mainBloc.setFcm(await _firebaseMessaging.getToken());
                          mainBloc.setDeviceName(androidDeviceInfo.model);
                          mainBloc
                              .setDeviceOs(androidDeviceInfo.version.release);
                          mainBloc.setUserName(user_name);
                          mainBloc.setUserPicture("");
//                          mainBloc.setUserPicture(user_picture);
                        } else if (Platform.isIOS) {
                          iosDeviceInfo = await deviceInfoPlugin.iosInfo;
                          print(
                              "deviceInfo : ${iosDeviceInfo.systemVersion}, ${iosDeviceInfo.model}");

                          mainBloc.setUserId(user_id);
                          mainBloc.setFcm(await _firebaseMessaging.getToken());
                          mainBloc.setDeviceName(iosDeviceInfo.model);
                          mainBloc.setDeviceOs(iosDeviceInfo.systemVersion);
                          mainBloc.setUserName(user_name);
                          mainBloc.setUserPicture("");
                        }

                        mainBloc.userAuth().then((value) async {
                          print(value);
                          dynamic valueResult = json.decode(value)['result'];
                          print('valueResult : ${valueResult}');
                          if (valueResult == 1) {
                            sharedSave(user_id, user_name, "",
                                await _firebaseMessaging.getToken());
                            CafeLogSnackBarWithOk(context: context, okMsg: "확인", msg: "인스타그램에 성공적으로 연동되었습니다.");
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "/Home", (Route<dynamic> route) => false);
                          } else if (valueResult == 0) {
                            mainBloc.setSoicalId(user_id);
                            mainBloc.getAuth().then((value) async {
                              if (json.decode(value)['data'] != null) {
                                AuthData auth = AuthData(
                                    soicalId: json.decode(value)['data']
                                        ['soical_id'],
                                    userName: json.decode(value)['data']
                                        ['user_name'],
                                    userPicture: json.decode(value)['data']
                                        ['user_picture'],
                                    fcmKey: json.decode(value)['data']
                                        ['fcm_key']);

                                mainBloc.authId = auth.soicalId;
                                mainBloc.authName = auth.userName;
                                mainBloc.authPicture = auth.userPicture;
                                mainBloc.authToken = auth.fcmKey;

                                sharedSave(
                                    auth.soicalId,
                                    auth.userName,
                                    "",
                                    await _firebaseMessaging.getToken());
                                mainBloc.updateFcmKey(await _firebaseMessaging.getToken(), auth.soicalId);
                                CafeLogSnackBarWithOk(context: context, okMsg: "확인", msg: "${auth.userName}님 반갑습니다.");
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/Home", (Route<dynamic> route) => false);
                              } else {
                          CafeLogSnackBarWithOk(msg: "회원가입에 실패했습니다 잠시 후 다시시도해주세요.", context: context, okMsg: "확인");
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        });
                      });
                    }
                  },
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ),
        ));
  }
}
