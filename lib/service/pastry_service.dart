import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:gelic_bakes/models/pastry.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/add/add_item.dart';
import 'package:gelic_bakes/ui/pages/orders.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';

class PastryService {
  final firestoreService = FirebaseFirestore.instance;

  //create a pastry ........................................................
  Future<void> createNewPastry(Pastry pastry, BuildContext context) {
    return firestoreService
        .collection('Pastry')
        .add(pastry.toMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

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
    Navigator.of(context).pushNamed(
      OrdersPage.routeName,
    );
  }

  showSuccess(context) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pushReplacementNamed(
      AddItem.routeName,
    );
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}