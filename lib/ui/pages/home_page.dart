import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/categories.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/fresh_from_oven.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/special_offers.dart';

class Home extends StatefulWidget with NavigationState {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: sixDp,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: [
          // SizedBox(height: eightyDp,),
          FreshFromOven(),
          Category(),
          SizedBox(
            height: thirtyDp,
          ),
          SpecialOffers(),
        ],
      )),
    );
  }
}
