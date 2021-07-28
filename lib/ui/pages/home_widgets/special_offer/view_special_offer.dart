import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';

class ViewSpecialOffers extends StatefulWidget {
  static const routeName = '/viewSpecialOffer';

  const ViewSpecialOffers({Key? key}) : super(key: key);

  @override
  _ViewSpecialOffersState createState() => _ViewSpecialOffersState();
}

class _ViewSpecialOffersState extends State<ViewSpecialOffers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: EdgeInsets.all(tenDp),
            decoration: BoxDecoration(
                border: Border.all(width: 0.3, color: Colors.grey),
                color: Colors.pink,
                borderRadius: BorderRadius.circular(thirtyDp)),
            child: Padding(
              padding: EdgeInsets.all(eightDp),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: sixteenDp,
              ),
            ),
          ),
        ),
        title: Text(
          specialOffer,
          style: TextStyle(color: Colors.pink),
        ),
      ),
    );
  }
}
