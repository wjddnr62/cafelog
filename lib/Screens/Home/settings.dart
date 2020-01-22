import 'package:cafelog/Screens/Home/withdrawal.dart';
import 'package:cafelog/Util/whiteSpace.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';

class Setting extends StatefulWidget {

  String id;

  Setting({Key key, this.id}) : super(key:key);

  @override
  _Setting createState() => _Setting();
}

class _Setting extends State<Setting> {

  bool _switch = true;

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
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: White,
        title: Text("설정", style: TextStyle(
          color: Black, fontSize: 16, fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20
                , right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Withdrawal(
                  id: widget.id,
                )));
              },
              child: Text("회원탈퇴", style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, color: mainColor
              ),),
            ),
          )
        ],
      ),
      backgroundColor: White,
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            whiteSpaceH(20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("위치서비스", style: TextStyle(
                    color: Black, fontSize: 18, fontWeight: FontWeight.bold
                  ),),
                ),
                Switch(
                  value: _switch,
                  onChanged: (value) {
                    setState(() {
                      _switch = value;
                    });
                  },
                  activeColor: mainColor,
                )
              ],
            ),
            whiteSpaceH(20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("버전정보", style: TextStyle(
                        color: Black, fontSize: 18, fontWeight: FontWeight.bold
                    ),),
                  ),
                  Text("현재 1.0.0", style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14, color: Color.fromARGB(255, 167, 167, 167)
                  ),),
                  whiteSpaceW(20),
                  Text("최신 1.0.0", style: TextStyle(
                      color: mainColor, fontSize: 14, fontWeight: FontWeight.w600
                  ),)
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text("광고문의", style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Black
              ),),
            ),
            whiteSpaceH(25),
            GestureDetector(
              onTap: () {},
              child: Text("공지사항", style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Black
              ),),
            ),
            whiteSpaceH(25),
            GestureDetector(
              onTap: () {},
              child: Text("고객센터", style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Black
              ),),
            ),
            whiteSpaceH(50)
          ],
        ),
      ),
    );
  }

}