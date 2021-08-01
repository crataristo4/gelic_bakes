import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'datasource.dart';

class ProductListBloc {
  FirebaseDataProvider? firebaseDataProvider;

  bool showIndicator = false;
  List<DocumentSnapshot>? documentList;

  BehaviorSubject<List<DocumentSnapshot>>? listItemController;

  BehaviorSubject<bool>? showIndicatorController;

  ProductListBloc() {
    listItemController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseDataProvider = FirebaseDataProvider();
  }

  Stream get getShowIndicatorStream => showIndicatorController!.stream;

  Stream<List<DocumentSnapshot>> get itemListStream =>
      listItemController!.stream;

  //-----------------FRESH FROM OVEN --------------------------------------------//
  Future fetchPopularProduct(CollectionReference collectionReference) async {
    try {
      documentList =
          await firebaseDataProvider!.fetchPopularProduct(collectionReference);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

  //paginate next pastries
  fetchNextPopularProductListItems(
      CollectionReference collectionReference) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await firebaseDataProvider!
          .fetchNextPopularProductListItems(collectionReference, documentList!);
      documentList!.addAll(newDocumentList);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

  //........................FETCH ALL PASTRIES........................................................//

  Future fetchProducts(CollectionReference collectionReference) async {
    try {
      documentList =
          await firebaseDataProvider!.fetchProducts(collectionReference);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

//paginate next pastries
  fetchNextProducts(CollectionReference collectionReference) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await firebaseDataProvider!
          .fetchNextProducts(collectionReference, documentList!);
      documentList!.addAll(newDocumentList);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

  //..................................END FETCH................................................................//

//-----FETCH category list -----------------------------------------------------------//
  Future fetchCategoryList(
      CollectionReference collectionReference, String category) async {
    try {
      documentList = await firebaseDataProvider!
          .fetchCategoryList(collectionReference, category);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

//paginate category
  fetchNextCategoryListItems(
      CollectionReference collectionReference, String category) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await firebaseDataProvider!
          .fetchNextCategoryListItems(
              collectionReference, category, documentList!);
      documentList!.addAll(newDocumentList);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

//-------------------------END--------------------------------------------------------//

//.................FETCH ORDERS (user)....................................................//
  Future fetchOrders(CollectionReference collectionReference) async {
    try {
      documentList =
          await firebaseDataProvider!.fetchOrders(collectionReference);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

//paginate next orders user
  fetchNextOrderListItems(CollectionReference collectionReference) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await firebaseDataProvider!
          .fetchNextOrderListItems(collectionReference, documentList!);
      documentList!.addAll(newDocumentList);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

  //.....................END.........................................//

  //.................FETCH all promotion....................................................//
  Future fetchPromotion(
      CollectionReference collectionReference, String category) async {
    try {
      documentList = await firebaseDataProvider!
          .fetchPromotion(collectionReference, category);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

//paginate category
  fetchNextPromotion(
      CollectionReference collectionReference, String category) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await firebaseDataProvider!
          .fetchNextPromotion(collectionReference, category, documentList!);
      documentList!.addAll(newDocumentList);
      listItemController!.sink.add(documentList!);
      try {
        if (documentList!.length == 0) {
          listItemController!.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      listItemController!.sink
          .addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      listItemController!.sink.addError(e);
    }
  }

  //.....................END.........................................//

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController!.sink.add(value);
  }

  void dispose() {
    listItemController!.close();
    showIndicatorController!.close();
  }
}
