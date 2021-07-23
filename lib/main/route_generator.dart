import 'package:flutter/material.dart';
import 'package:gelic_bakes/models/pastry.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/auth/register.dart';
import 'package:gelic_bakes/ui/auth/verify.dart';
import 'package:gelic_bakes/ui/bottomsheets/pre_order.dart';
import 'package:gelic_bakes/ui/onboarding/onboarding_page.dart';
import 'package:gelic_bakes/ui/pages/acount_page.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/add/add_item.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/category/item_category.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/fresh_from_oven/view_all_fresh_from_oven.dart';
import 'package:gelic_bakes/ui/pages/orders.dart';

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

      //fresh from oven
      case ViewAllFreshFromOven.routeName:
        return MaterialPageRoute(builder: (_) => ViewAllFreshFromOven());

      //account page
      case AccountPage.routeName:
        final data = settings.arguments as bool;
        return MaterialPageRoute(
            builder: (_) => AccountPage(
                  hasProfile: data,
                ));

      //list items by category
      case CategoryItems.routeName:
        final data = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => CategoryItems(
                  category: data,
                ));

      //add item
      case AddItem.routeName:
        return MaterialPageRoute(builder: (_) => AddItem());

      //place order
      case PreOrder.routeName:
        final data = settings.arguments as Pastry;
        return MaterialPageRoute(
            builder: (_) => PreOrder(
                  pastry: Pastry(
                      name: data.name,
                      category: data.category,
                      image: data.image,
                      price: data.price),
                ));

      // orders page
      case OrdersPage.routeName:
        return MaterialPageRoute(builder: (_) => OrdersPage());

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
