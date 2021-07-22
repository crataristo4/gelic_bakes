import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'datasource.dart';

class PastryListBloc {
  FirebaseDataProvider? firebaseDataProvider;

  bool showIndicator = false;
  List<DocumentSnapshot>? documentList;

  BehaviorSubject<List<DocumentSnapshot>>? listItemController;

  BehaviorSubject<bool>? showIndicatorController;

  PastryListBloc() {
    listItemController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseDataProvider = FirebaseDataProvider();
  }

  Stream get getShowIndicatorStream => showIndicatorController!.stream;

  Stream<List<DocumentSnapshot>> get itemListStream =>
      listItemController!.stream;

  //-----------------FRESH FROM OVEN --------------------------------------------//
  Future fetchFreshFromOven(CollectionReference collectionReference) async {
    try {
      documentList =
          await firebaseDataProvider!.fetchFreshFromOven(collectionReference);
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

  //........................FETCH ALL PASTRIES........................................................//

  Future fetchPastries(CollectionReference collectionReference) async {
    try {
      documentList =
          await firebaseDataProvider!.fetchAllPastries(collectionReference);
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
  fetchNextPastryListItems(CollectionReference collectionReference) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await firebaseDataProvider!
          .fetchNextPastryListItems(collectionReference, documentList!);
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
