import 'package:flutter/material.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/auth/register.dart';
import 'package:gelic_bakes/ui/auth/verify.dart';
import 'package:gelic_bakes/ui/onboarding/onboarding_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //user config state checker Screen
      case ConfigurationPage.routeName:
        return MaterialPageRoute(builder: (_) => ConfigurationPage());

      //shows when user newly installs the application
      case OnboardingPage.routeName:
        return MaterialPageRoute(builder: (_) => OnboardingPage());

      //screen to register new users / login
      case RegistrationPage.routeName:
        return MaterialPageRoute(builder: (_) => RegistrationPage());

      //verify users phone number
      case VerificationPage.routeName:
        final data = settings.arguments as String;

        return MaterialPageRoute(
            builder: (_) => VerificationPage(
                  phoneNumber: data,
                ));

      default:
        return _errorRoute();
    }
  }

  //error page ..
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text("Page not Found"),
        ),
      );
    });
  }
}
