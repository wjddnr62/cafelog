import 'package:cafelog/Bloc/mainBloc.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:cafelog/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Withdrawal extends StatefulWidget {
  String id;

  Withdrawal({Key key, this.id}) : super(key: key);

  @override
  _Withdrawal createState() => _Withdrawal();
}

class _Withdrawal extends State<Withdrawal> {

  MainBloc _mainBloc = MainBloc();

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  sharedInit() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.of(context).pushNamedAndRemoveUntil('/LoginMain', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          color: mainColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0.6,
      ),
      backgroundColor: White,
      appBar: AppBar(
        backgroundColor: White,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "회원탈퇴",
          style: TextStyle(
              color: Black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: <Widget>[
            whiteSpaceH(MediaQuery.of(context).size.height / 6),
            Expanded(
              child: Text(
                "회원탈퇴 하실 경우,\n현재 소유하고 계신\n모든 개인 정보가 사라집니다.\n그래도 정말 탈퇴하시겠습니까?",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 22, color: Black),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _mainBloc.setFavoriteId(widget.id);
                        _mainBloc.deleteAuthFavorite().then((value) {
                          _mainBloc.deleteAuth().then((value) {
                            sharedInit();
                          });
                        });
                      },
                      child: Container(
                        width: 120,
                        height: 44,
                        decoration: BoxDecoration(
                            color: White,
                            borderRadius: BorderRadius.circular(22)),
                        child: Center(
                          child: Text(
                            "네",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  whiteSpaceW(20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 120,
                        height: 44,
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(22)),
                        child: Center(
                          child: Text(
                            "취소",
                            style: TextStyle(
                                color: White,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            whiteSpaceH(MediaQuery.of(context).size.height / 6),
          ],
        ),
      ),
    );
  }
}
