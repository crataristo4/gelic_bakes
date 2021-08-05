import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

//version 2
int? onboardingPrefs;
final GlobalKey<State> loadingKey = new GlobalKey<State>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  onboardingPrefs = prefs.getInt("onboarding");
  await prefs.setInt("onboarding", 1);

  //location notification

  var initializationSettingsAndroid =
      AndroidInitializationSettings('launch_image');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

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
