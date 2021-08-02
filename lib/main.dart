import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelic_bakes/models/reviews.dart';
import 'package:gelic_bakes/provider/auth_provider.dart';
import 'package:gelic_bakes/provider/promo_provider.dart';
import 'package:gelic_bakes/provider/review_provider.dart';
import 'package:gelic_bakes/service/review_service.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/onboarding/onboarding_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main/route_generator.dart';
import 'models/promotion.dart';
import 'service/promo_service.dart';

int? onboardingPrefs;
final GlobalKey<State> loadingKey = new GlobalKey<State>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  onboardingPrefs = prefs.getInt("onboarding");
  await prefs.setInt("onboarding", 1);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(EntryPoint()));
}

class EntryPoint extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //authentication
        ChangeNotifierProvider.value(value: AuthProvider()),
        //reviews
        ChangeNotifierProvider.value(value: ReviewProvider()),
        ChangeNotifierProvider.value(value: PromoProvider()),

        //fetch review by id
        StreamProvider<List<Reviews>>.value(
          lazy: false,
          initialData: [],
          value: ReviewService().getReviewsById(),
        ),

        //fetch promo
        StreamProvider<List<Promotion>>.value(
          lazy: false,
          initialData: [],
          value: PromoService().getPromos(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          primaryColor: Colors.pink,
        ),
        initialRoute: onboardingPrefs == 0 || onboardingPrefs == null
            ? OnboardingPage
                .routeName //shows when app data is cleared or newly installed
            : ConfigurationPage.routeName,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
