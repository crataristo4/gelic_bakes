import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:gelic_bakes/ui/pages/orders.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';

class OrderService {
  final firestoreService = FirebaseFirestore.instance;

//..............................................................................

  //create order ...............................................................
  Future<void> createNewOrder(Orders orders, BuildContext context) {
    return firestoreService
        .collection('Orders')
        .add(orders.toMap())
        .whenComplete(() async {
      showOrderSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //...........................................................................

  showOrderSuccess(context) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop();

    Navigator.of(context).pushNamed(
      OrdersPage.routeName,
    );
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
