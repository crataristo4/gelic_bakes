import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';

class AccountPage extends StatefulWidget with NavigationState {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text("account"),
      ),
    );
  }
}
