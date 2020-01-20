import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../colors.dart';

class NaverCafeInfo extends StatefulWidget {
  String url;

  NaverCafeInfo({Key key, this.url}) : super(key: key);

  @override
  _NaverCafeInfo createState() => _NaverCafeInfo();
}

class _NaverCafeInfo extends State<NaverCafeInfo> {
  String loadCompleteUrl;
  bool firstLoad = false;
  WebViewController _webViewController;
  String naverInfoUrl;

  @override
  void initState() {
    super.initState();

//    naverInfoUrl = "https://store.naver.com/restaurants/detail?id=971501438";
      naverInfoUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: WillPopScope(
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (loadCompleteUrl == null) {
                  Navigator.of(context).pop();
                } else {
                  _webViewController.currentUrl().then((value) {
                    print("url : " + value + ", " + loadCompleteUrl);
                    if (value != loadCompleteUrl) {
                      _webViewController.goBack();
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
                }
              },
              child: Icon(
                Icons.arrow_back,
                color: mainColor,
              ),
              backgroundColor: Colors.white,
              elevation: 0.6,
            ),
            backgroundColor: White,
            resizeToAvoidBottomInset: true,
            body: WebView(
              initialUrl: naverInfoUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (_webController) {
                _webController.clearCache();
                _webViewController = _webController;
              },
              onPageFinished: (url) {
                print("check : " + url);
                if (url.contains("place")) {
                  if (firstLoad == false) {
                    loadCompleteUrl = url;
                    firstLoad = true;
                  }
                }
              },
            ),
          )),
    );
  }
}
