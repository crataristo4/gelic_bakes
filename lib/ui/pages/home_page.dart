import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/service/admob_service.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/category/categories.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/special_offers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'home_widgets/popular/popular_products.dart';

class Home extends StatefulWidget with NavigationState {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AdmobService _admobService = AdmobService(); //Ads

  _HomeState() {
    Timer(Duration(seconds: 30), () {
      _admobService.showInterstitialAd();
    });
  }

  @override
  void initState() {
    _admobService.createInterstitialAd();
    super.initState();
  }

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
       /*   Container(
            height: sixtyDp,
            child: AdWidget(
              ad: AdmobService.createBannerSmall()..load(),
              key: UniqueKey(),
            ),
          ),*/
          PopularProduct(),
          SizedBox(
            height: tenDp,
          ),
          Category(),
          SizedBox(
            height: twentyDp,
          ),
          /* Container(
            height: sixtyDp,
            child: AdWidget(
              ad: AdmobService.createBannerSmall()..load(),
              key: UniqueKey(),
            ),
          ),*/
          SpecialOffers(),
          SizedBox(
            height: twentyDp,
          ),
        ],
      )),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: sixDp),
        height: sixtyDp,
        child: AdWidget(
          ad: AdmobService.createBannerSmall()..load(),
          key: UniqueKey(),
        ),
      ),
    );
  }
}
