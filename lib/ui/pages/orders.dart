import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';

class OrdersPage extends StatefulWidget with NavigationState {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text("orders"),
      ),
    );
  }
}
