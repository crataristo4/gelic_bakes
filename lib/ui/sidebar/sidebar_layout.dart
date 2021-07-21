import 'package:flutter/material.dart';
import 'package:gelic_bakes/ui/pages/homepage.dart';
import 'package:gelic_bakes/ui/sidebar/sidebar.dart';

class SidebarLayout extends StatelessWidget {
  const SidebarLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Home(), SidebarItem()],
      ),
    );
  }
}
