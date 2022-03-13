import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String title, Color bgColor) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: bgColor,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        Text(title,
                            style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.w700)),
                        SizedBox(
                          height: 15,
                        ),
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          pleaseWait,
                          style: TextStyle(color: Colors.pinkAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
