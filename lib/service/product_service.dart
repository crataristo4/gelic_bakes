import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/product.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';

class ProductService {
  final firestoreService = FirebaseFirestore.instance;


  //update Product name
  Future<void> updateProductName(
      Product product, BuildContext context, String itemId) {
    return firestoreService
        .collection('Product')
        .doc(itemId)
        .update(product.nameToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update Product category
  Future<void> updateProductCategory(
      Product product, BuildContext context, String itemId) {
    return firestoreService
        .collection('Product')
        .doc(itemId)
        .update(product.categoryToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update Product price
  Future<void> updateProductPrice(
      Product product, BuildContext context, String itemId) {
    return firestoreService
        .collection('Product')
        .doc(itemId)
        .update(product.priceToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update Product des
  Future<void> updateProductDes(
      Product product, BuildContext context, String itemId) {
    return firestoreService
        .collection('Product')
        .doc(itemId)
        .update(product.descriptionToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update Product image
  Future<void> updateProductImage(
      Product product, BuildContext context, String itemId) {
    return firestoreService
        .collection('Product')
        .doc(itemId)
        .update(product.imageToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update Product image
  Future<void> updateNameAndPrice(
      Product product, BuildContext context, String itemId) {
    return firestoreService
        .collection('Product')
        .doc(itemId)
        .update(product.nameAndPriceToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update Product name and description
  Future<void> updateNameAndDescription(
      Product product, BuildContext context, String itemId) {
    return firestoreService
        .collection('Product')
        .doc(itemId)
        .update(product.nameAndDescriptionToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update Product name , price and description
  Future<void> updateNamePriceAndDescription(
      Product product, BuildContext context, String itemId) {
    return firestoreService
        .collection('Product')
        .doc(itemId)
        .update(product.namePriceAndDescriptionToMap())
        .whenComplete(() async {
      showUpdatingSuccessful(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

//..............................................................................

  //...........................................................................

  showUpdatingSuccessful(context) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    // Navigator.of(context, rootNavigator: true).pop();
  }


  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
