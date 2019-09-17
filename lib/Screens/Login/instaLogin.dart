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
                      style: TextStyle(fontSize: 14, color: mainColor, fontWeight: FontWeight.bold),
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
    return Scaffold(
      backgroundColor: White,
      appBar: instaAppBar(),
      resizeToAvoidBottomInset: true,
      body: WebView(
          initialUrl: 'https://www.instagram.com/oauth/authorize/?client_id=${testClientId}&redirect_uri=${redirectUrl}&response_type=code',
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (url) {
            print(url);
            if (url.contains('laonstory')) {
//              List<String> test = url.split("=");
//              print("test : " + test[1]);
//              print(instaUserInfo(test[1]));
//              Navigator.of(context).pop();
            }
//            print("finished:" + url);
          },
        ),

    );
  }
}
