import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstaLogin extends StatefulWidget {
  @override
  _InstaLogin createState() => _InstaLogin();
}

class _InstaLogin extends State<InstaLogin> {
  String redirectUrl = "http://laonstory.com";
  String testClientId = "6b1dffbc60234670a25aa8336334bf0e";

  String instaLoginUrl;
  String loadCompleteUrl;

  bool firstLoad = false;

  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    instaLoginUrl =
        'https://www.instagram.com/oauth/authorize/?client_id=${testClientId}&redirect_uri=${redirectUrl}&response_type=token';
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
          body: WebView(
            initialUrl: instaLoginUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (_webController) {
              _webController.clearCache();
              _webViewController = _webController;
            },
            onPageFinished: (url) {

              if (firstLoad == false) {
                loadCompleteUrl = url;
                firstLoad = true;
              }

              if (url.contains('access_token')) {
                List<String> access_token = url.split("=");
                print(access_token[1]);
                Navigator.of(context).pop();
              }
            },
          ),
        ));
  }
}
