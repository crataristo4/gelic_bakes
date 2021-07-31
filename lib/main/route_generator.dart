import 'package:flutter/material.dart';
import 'package:gelic_bakes/models/product.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/auth/register.dart';
import 'package:gelic_bakes/ui/auth/verify.dart';
import 'package:gelic_bakes/ui/bottomsheets/add_review.dart';
import 'package:gelic_bakes/ui/bottomsheets/pre_order.dart';
import 'package:gelic_bakes/ui/onboarding/onboarding_page.dart';
import 'package:gelic_bakes/ui/pages/acount_page.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/category/details_psge.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/category/item_category.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/popular/view_popular_products.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/reviews_page.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/special_offer/view_special_offer.dart';
import 'package:gelic_bakes/ui/pages/orders.dart';
import 'package:gelic_bakes/ui/sidebar/sidebar_layout.dart';

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

      // SidebarLayout
      case SidebarLayout.routeName:
        final data = settings.arguments as bool;
        return MaterialPageRoute(builder: (_) => SidebarLayout());

      //fresh from oven
      case ViewAllPopularProduct.routeName:
        return MaterialPageRoute(builder: (_) => ViewAllPopularProduct());

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

      //place order
      case PreOrder.routeName:
        final data = settings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => PreOrder(
                  product: Product(
                      name: data.name,
                      category: data.category,
                      image: data.image,
                      price: data.price),
                ));

      //details page
      case DetailsPage.routeName:
        final data = settings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => DetailsPage(
                  product: Product(
                      name: data.name,
                      category: data.category,
                      image: data.image,
                      price: data.price,
                      description: data.description),
                ));

      // users orders page
      case UsersOrdersPage.routeName:
        final data = settings.arguments as bool;
        return MaterialPageRoute(builder: (_) => UsersOrdersPage(isBack: data));

      //view special offer
      case ViewSpecialOffers.routeName:
        final data = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => ViewSpecialOffers(
                  category: data,
                ));
      //add reviews
      case AddReviewPage.routeName:
        return MaterialPageRoute(builder: (_) => AddReviewPage());

//reviews page
      case ReviewsPage.routeName:
        final data = settings.arguments as bool;
        return MaterialPageRoute(builder: (_) => ReviewsPage());

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
