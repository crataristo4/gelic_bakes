import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';

class SideBarMenuItems extends StatelessWidget {
  final iconData, title;

  const SideBarMenuItems({Key? key, this.iconData, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(twentyDp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Icon(
              iconData,
              color: Colors.white,
              size: twentyDp,
            ),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(sixDp)),
            width: fiftyDp,
            height: fiftyDp,
          ),
          SizedBox(
            width: tenDp,
          ),
          Padding(
            padding: const EdgeInsets.only(top: sixteenDp),
            child: Text(
              title,
              style: TextStyle(fontSize: fourteenDp, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
