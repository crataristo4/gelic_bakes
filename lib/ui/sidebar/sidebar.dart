import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
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
            right: snapshot.data! ? 0 : screenWidth - 45,
            bottom: 0,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  color: Colors.pink,
                  child: Column(
                    children: [
                      SizedBox(
                        height: hundredDp,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          radius: fortyDp,
                        ),
                        title: Text('name'),
                        subtitle: Text('number'),
                      ),
                      Divider(
                        color: Colors.white,
                        indent: thirtyTwoDp,
                        endIndent: thirtyTwoDp,
                      ),
                      SideBarMenuItems(
                        iconData: Icons.home_outlined,
                        title: home,
                      ),
                      SideBarMenuItems(
                        iconData: Icons.perm_identity_sharp,
                        title: account,
                      ),
                      SideBarMenuItems(
                        iconData: Icons.shopping_basket,
                        title: orders,
                      ),
                      SideBarMenuItems(
                        iconData: Icons.notifications,
                        title: notifications,
                      ),
                      SideBarMenuItems(
                        iconData: Icons.exit_to_app,
                        title: logOut,
                      ),
                    ],
                  ),
                )),
                Align(
                  alignment: Alignment(0, -0.81),
                  child: GestureDetector(
                    onTap: () {
                      triggerSideBar();
                    },
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
                )
              ],
            ),
          );
        });
  }
}
