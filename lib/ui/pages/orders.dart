import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';

class OrdersPage extends StatefulWidget with NavigationState {
  static const routeName = '/orderPage';

  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        child: Center(
          child: Text("orders"),
        ),
      ),
    );
  }
}
