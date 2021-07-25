import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:gelic_bakes/models/product.dart';
import 'package:gelic_bakes/ui/admin/admin_page.dart';
import 'package:gelic_bakes/ui/pages/orders.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';

class ProductService {
  final firestoreService = FirebaseFirestore.instance;

  //create a Product ........................................................
  Future<void> createNewProduct(Product product, BuildContext context) {
    // if(Product.category == vaginne || Product.category == adwelle || Product.category == vtide)
    return firestoreService
        .collection(product.category == vaginne ||
                product.category == adwelle ||
                product.category == vtide
            ? "Medicine"
            : 'Product')
        .add(product.toMap())
        .whenComplete(() async {
      showSuccess(context, product.category);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

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

  showSuccess(context, category) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    //push to medicine page
    if (category == vaginne || category == vtide || category == adwelle) {
      Navigator.of(context)
          .pushReplacementNamed(AdminPage.routeName, arguments: 2);
    } else {
      //push to pastry page
      Navigator.of(context)
          .pushReplacementNamed(AdminPage.routeName, arguments: 1);
    }
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
