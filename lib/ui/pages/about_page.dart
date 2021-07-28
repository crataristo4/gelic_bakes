import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';

class AboutPage extends StatelessWidget with NavigationState {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            aboutUs,
            style: TextStyle(color: Colors.pink),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ));
  }
}
