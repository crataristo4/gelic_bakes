import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/service/admob_service.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/widgets/onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  static const routeName = '/onboarding';

  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController? _pageController;
  int currentIndex = 0;
  AdmobService admobService = AdmobService();

  _OnboardingPageState() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      admobService.showInterstitialAd();
    });
  }

  @override
  void initState() {
    admobService.createInterstitialAd();
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.all(tenDp),
            child: GestureDetector(
              onTap: () {
                pushToConfigPage();
              },
              child: Text(
                labelSkip,
                style: TextStyle(
                    fontSize: twentyDp,
                    color: Colors.pink,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: [
              OnboardingSlideItem(
                image: "assets/images/cake.jpg",
                title: pastries,
                content: cakeDes,
              ),
              OnboardingSlideItem(
                image: "assets/images/fj.jpg",
                title: fruitJuice,
                content: fruitJuiceDes,
                reverse: true,
              ),
              OnboardingSlideItem(
                image: "assets/images/vaginne.jpg",
                title: immeri,
                content: vaginneDes,
              ),
              OnboardingSlideItem(
                image: "assets/images/shoe.jpg",
                title: shoes,
                content: "",
              ),
              OnboardingSlideItem(
                image: "assets/images/wig.jpg",
                title: wigs,
                content: wigsDes,
                reverse: true,
              ),


            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: hundredDp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: indicatorCount(),
            ),
          ),
          currentIndex != 4
              ? Container()
              : InkWell(
            onTap: () {
              pushToConfigPage();
            },
            child: Container(
              height: Platform.isIOS ? 70 : 60,
              color: Theme.of(context).primaryColor,
              alignment: Alignment.center,
              child: Text(
                labelGetStarted,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: eightDp,
      width: isActive ? thirtyDp : eightDp,
      margin: EdgeInsets.only(right: sixDp),
      decoration: BoxDecoration(
          color: Colors.pink, borderRadius: BorderRadius.circular(fourDp)),
    );
  }

  List<Widget> indicatorCount() {
    List<Widget> indicators = [];
    for (int i = 0; i < 4; i++) {
      if (currentIndex == i) {
        indicators.add(indicator(true));
      } else {
        indicators.add(indicator(false));
      }
    }

    return indicators;
  }

  pushToConfigPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(ConfigurationPage.routeName, (route) => false);
  }
}
