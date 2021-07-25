import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:gelic_bakes/models/pastry.dart';
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

  //update pastry name
  Future<void> updatePastryName(
      Pastry pastry, BuildContext context, String itemId) {
    return firestoreService
        .collection('Pastry')
        .doc(itemId)
        .update(pastry.nameToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update pastry category
  Future<void> updatePastryCategory(
      Pastry pastry, BuildContext context, String itemId) {
    return firestoreService
        .collection('Pastry')
        .doc(itemId)
        .update(pastry.categoryToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update pastry price
  Future<void> updatePastryPrice(
      Pastry pastry, BuildContext context, String itemId) {
    return firestoreService
        .collection('Pastry')
        .doc(itemId)
        .update(pastry.priceToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update pastry des
  Future<void> updatePastryDes(
      Pastry pastry, BuildContext context, String itemId) {
    return firestoreService
        .collection('Pastry')
        .doc(itemId)
        .update(pastry.descriptionToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update pastry image
  Future<void> updatePastryImage(
      Pastry pastry, BuildContext context, String itemId) {
    return firestoreService
        .collection('Pastry')
        .doc(itemId)
        .update(pastry.imageToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update pastry image
  Future<void> updateNameAndPrice(
      Pastry pastry, BuildContext context, String itemId) {
    return firestoreService
        .collection('Pastry')
        .doc(itemId)
        .update(pastry.nameAndPriceToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update pastry name and description
  Future<void> updateNameAndDescription(
      Pastry pastry, BuildContext context, String itemId) {
    return firestoreService
        .collection('Pastry')
        .doc(itemId)
        .update(pastry.nameAndDescriptionToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update pastry name , price and description
  Future<void> updateNamePriceAndDescription(
      Pastry pastry, BuildContext context, String itemId) {
    return firestoreService
        .collection('Pastry')
        .doc(itemId)
        .update(pastry.namePriceAndDescriptionToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
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

  showUpdatingSuccessful(context) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    // Navigator.of(context, rootNavigator: true).pop();
  }

  showSuccess(context) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
