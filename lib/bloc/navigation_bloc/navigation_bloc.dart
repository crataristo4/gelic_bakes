/*import 'package:flutter_bloc/flutter_bloc.dart';*/
import 'package:bloc/bloc.dart';
import 'package:gelic_bakes/ui/pages/about_page.dart';
import 'package:gelic_bakes/ui/pages/acount_page.dart';
import 'package:gelic_bakes/ui/pages/home_page.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/reviews_page.dart';
import 'package:gelic_bakes/ui/pages/notification_page.dart';
import 'package:gelic_bakes/ui/pages/orders.dart';

enum NavigationEvents {
  onHomeClickEvent,
  onAccountClickEvent,
  onOrdersClickEvent,
  onNotificationClickEvent,
  onReviewPageClickEvent,
  onAboutPageClickEvent,
}

abstract class NavigationState {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationState> {
  NavigationBloc(NavigationState initialState) : super(initialState);

  NavigationState get initialState => Home();

  @override
  Stream<NavigationState> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.onHomeClickEvent:
        yield Home();
        break;

      case NavigationEvents.onAccountClickEvent:
        yield AccountPage(
          hasProfile: true,
        );
        break;
      case NavigationEvents.onOrdersClickEvent:
        yield UsersOrdersPage(
          isBack: false,
        );
        break;
      case NavigationEvents.onNotificationClickEvent:
        yield NotificationPage();
        break;
      case NavigationEvents.onReviewPageClickEvent:
        yield ReviewsPage();
        break;

      case NavigationEvents.onAboutPageClickEvent:
        yield AboutPage();
        break;
    }
  }
}
