import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/service/location_service.dart';
import 'package:gelic_bakes/service/user_services.dart';
import 'package:gelic_bakes/ui/pages/home_page.dart';
import 'package:gelic_bakes/ui/sidebar/sidebar.dart';

class SidebarLayout extends StatefulWidget {
  static const routeName = '/sidebar';

  const SidebarLayout({Key? key}) : super(key: key);

  @override
  _SidebarLayoutState createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  GetLocationService locationService = GetLocationService();

  @override
  void initState() {
    UserService().getCurrentUser(context);
    locationService.getUserCoordinates(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocProvider(
          lazy: false,
          create: (context) => NavigationBloc(Home()),
          child: Stack(
            children: [
              BlocBuilder<NavigationBloc, NavigationState>(
                builder: (context, navigationState) {
                  return navigationState as Widget;
                },
              ),
              SidebarItem()
            ],
          ),
        ));
  }
}
