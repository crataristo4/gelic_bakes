import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';

class Home extends StatefulWidget with NavigationState {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text("home"),
      ),
    );
  }
}
