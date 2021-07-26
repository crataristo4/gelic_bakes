import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:gelic_bakes/ui/admin/admin_page.dart';
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

  //update delivery fee ...............................................................
  Future<void> updateDeliveryFee(
      Orders orders, String id, BuildContext context) {
    return firestoreService
        .collection('Orders')
        .doc(id)
        .update(orders.deliveryFeeToMap())
        .whenComplete(() async {
      showDeliverySuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //manually update paid orders ...............................................................
  Future<void> updatePaidOrders(
      Orders orders, String id, BuildContext context) {
    return firestoreService
        .collection('Orders')
        .doc(id)
        .update(orders.isPaidToMap())
        .whenComplete(() async {
      showDeliverySuccess(context);
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

  showDeliverySuccess(context) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();

    Navigator.of(context)
        .pushReplacementNamed(AdminPage.routeName, arguments: 0);
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
