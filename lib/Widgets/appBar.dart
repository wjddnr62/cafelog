import 'package:flutter/material.dart';

import '../theme.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  String title, actionText;
  VoidCallback action, backAction;
  int checkView;

  AppBarCustom({Key key, this.title, this.actionText, this.action, this.backAction,this.checkView})
      : super(key: key);

  @override
  _AppBarCustom createState() => _AppBarCustom();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarCustom extends State<AppBarCustom> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: White,
      centerTitle: true,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            if (widget.checkView == 0) {
              setState(() {
                widget.backAction();
              });
            } else {
              Navigator.of(context).pop();
            }
          }),
      title: Text(
        widget.title,
        style: appBarText,
      ),
      elevation: 0.0,
      actions: <Widget>[
        widget.action != null
            ? Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    widget.action();
                  },
                  child: Center(
                    child: Text(
                      widget.actionText,
                      textAlign: TextAlign.center,
                      style: appBarActionText,
                    ),
                  ),
                ),
              )
            : Container(
                width: 0,
                height: 0,
              )
      ],
    );
  }
}
