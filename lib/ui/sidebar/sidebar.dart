import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/main.dart';
import 'package:gelic_bakes/ui/auth/register.dart';
import 'package:gelic_bakes/ui/pages/acount_page.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';
import 'package:gelic_bakes/ui/widgets/progress_dialog.dart';
import 'package:gelic_bakes/ui/widgets/sidebar_menu_items.dart';
import 'package:rxdart/rxdart.dart';

class SidebarItem extends StatefulWidget {
  const SidebarItem({Key? key}) : super(key: key);

  @override
  _SidebarItemState createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem>
    with SingleTickerProviderStateMixin<SidebarItem> {
  StreamController<bool>? _streamController;
  Stream<bool>? _stream;
  StreamSink<bool>? _streamSink;
  FocusNode? _focusNode;

  final bool isDrawerOpened = false;
  AnimationController? _animationController;
  final animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    _animationController =
        AnimationController(duration: animationDuration, vsync: this);
    _streamController = PublishSubject<bool>();
    _stream = _streamController!.stream;
    _streamSink = _streamController!.sink;
    super.initState();
  }

  @override
  void dispose() {
    _streamController!.close();
    _animationController!.dispose();
    _streamSink!.close();
    super.dispose();
  }

  void triggerSideBar() {
    final animationStatus = _animationController!.status;
    final animationCompleted = animationStatus == AnimationStatus.completed;

    if (animationCompleted) {
      _streamSink!.add(false);
      _animationController!.reverse();
    } else {
      _streamSink!.add(true);
      _animationController!.forward();
    }
  }

  logOut() {
    ShowAction.showAlertDialog(
        logout,
        logoutDes,
        context,
        TextButton(
          child: Text(
            noCancel,
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(yesLogMeOut, style: TextStyle(color: Colors.red)),
          onPressed: () async {
            //sign out from firebase
            await FirebaseAuth.instance.signOut();
            Dialogs.showLoadingDialog(
                //show dialog and delay
                context,
                loadingKey,
                loggingYouOut,
                Colors.white70);
            await Future.delayed(const Duration(seconds: 5));

            //close alert dialog
            Navigator.pop(context);
            //navigate to register
            Navigator.of(context).pushNamedAndRemoveUntil(
                RegistrationPage.routeName, (route) => false);
          },
        ));
  }

  navigateToProfile() {
    triggerSideBar();
    BlocProvider.of<NavigationBloc>(context)
        .add(NavigationEvents.onAccountClickEvent);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
        initialData: false,
        stream: _stream,
        builder: (context, snapshot) {
          return Positioned(
            top: 0,
            left: snapshot.data! ? 0 : -screenWidth,
            right: snapshot.data! ? 0 : screenWidth - 35,
            bottom: 0,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.pink,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: hundredDp,
                            ),
                            ListTile(
                              onTap: () => navigateToProfile(),
                              horizontalTitleGap: tenDp,
                              leading: Container(
                                width: sixtyDp,
                                height: sixtyDp,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.1, color: Colors.grey),
                                ),
                                child: ClipOval(
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    imageUrl: "${AccountPage.userImage}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${AccountPage.userName}',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text('${AccountPage.userPhone}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Divider(
                              color: Colors.white,
                              indent: thirtyTwoDp,
                              endIndent: thirtyTwoDp,
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SideBarMenuItems(
                                    iconData: Icons.home_outlined,
                                    title: home,
                                    onTap: () {
                                      triggerSideBar();
                                      BlocProvider.of<NavigationBloc>(context)
                                          .add(NavigationEvents
                                              .onHomeClickEvent);
                                    },
                                  ),
                                  /*      SideBarMenuItems(
                                    iconData: Icons.perm_identity_sharp,
                                    title: account,
                                    onTap: () => navigateToProfile(),
                                  ),*/
                                  SideBarMenuItems(
                                    iconData: Icons.shopping_basket,
                                    title: orders,
                                    onTap: () {
                                      triggerSideBar();
                                      BlocProvider.of<NavigationBloc>(context)
                                          .add(NavigationEvents
                                              .onOrdersClickEvent);
                                    },
                                  ),
                                  SideBarMenuItems(
                                    iconData: Icons.notifications,
                                    title: notifications,
                                    onTap: () {
                                      triggerSideBar();
                                      BlocProvider.of<NavigationBloc>(context)
                                          .add(NavigationEvents
                                              .onNotificationClickEvent);
                                    },
                                  ),
                                  SideBarMenuItems(
                                    iconData: Icons.exit_to_app,
                                    title: logout,
                                    onTap: () {
                                      //triggerSideBar();
                                      logOut();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment(0, -0.81),
                  child: GestureDetector(
                    onTap: () {
                      //if keyboard is opened close
                      _focusNode = FocusScope.of(context);
                      if (!_focusNode!.hasPrimaryFocus) {
                        _focusNode!.unfocus();
                      }
                      triggerSideBar();
                    },
                    child: ClipPath(
                      clipper: CustomMenuClipper(),
                      child: Container(
                        width: 35,
                        height: 110,
                        color: Colors.pink,
                        alignment: Alignment.centerLeft,
                        child: AnimatedIcon(
                          progress: _animationController!.view,
                          icon: AnimatedIcons.menu_close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
