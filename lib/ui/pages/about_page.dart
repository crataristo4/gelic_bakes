import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/service/admob_service.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

class AboutPage extends StatefulWidget with NavigationState {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey<State> _globalKey = new GlobalKey<State>();

  AdmobService _admobService = AdmobService();

  @override
  void initState() {
    super.initState();
    _admobService.createInterstitialAd();
  }

  _AboutPageState() {
    Timer(Duration(seconds: 10), () {
      _admobService.showInterstitialAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          aboutUs,
          style: TextStyle(color: Colors.pink),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: hundredDp,
              width: hundredDp,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(fortyDp),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/logo/logo.jpg'))),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, left: 26, right: 26),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: sixteenDp),
              child: Text(
                aboutGelicHub,
                // textAlign: TextAlign.start,
                style: TextStyle(
                  wordSpacing: 3,
                  letterSpacing: 3,
                  fontSize: twentyDp,
                ),
              ),
            ),
            /* Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => launchURL(WorkItConstants.privacyPolicyUrl),
                    child: Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        WorkItConstants.privacy,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        launchURL(WorkItConstants.termsAndConditionsUrl),
                    child: Container(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        WorkItConstants.terms,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 0,//sixtyDp,
        // child: AdWidget(
        //   ad: AdmobService.createBannerSmall()..load(),
        //   key: UniqueKey(),
        // ),
      ),
    );
  }

/*  launchURL(String url) async {
    Dialogs.showLoadingDialog(context, _globalKey, WorkItConstants.opening,
        Colors.white70); //start the dialog

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (await canLaunch(url)) {
        await new Future.delayed(const Duration(seconds: 3));
        setState(() {
          Navigator.of(_globalKey.currentContext, rootNavigator: true).pop();
        });

        await launch(
          url,
          forceWebView: false,
        );
      } else {
        //throw 'Could not launch $url';
        setState(() {
          Navigator.of(_globalKey.currentContext, rootNavigator: true).pop();
        });
        ShowAction().showToast("Could not launch url", Colors.black);
      }
    } else {
      await new Future.delayed(const Duration(seconds: 2));
      Navigator.of(context, rootNavigator: true).pop(); //close the dialog
      ShowAction().showToast(WorkItConstants.unableToConnect, Colors.black);
    }
  }*/
}
