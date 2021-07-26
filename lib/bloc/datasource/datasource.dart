import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gelic_bakes/ui/auth/config.dart';

class FirebaseDataProvider {
  //fetch all pastries ---------------------------------------------------------------//
  Future<List<DocumentSnapshot>> fetchProducts(
      CollectionReference collectionReference) async {
    return (await collectionReference
            .orderBy("name", descending: false)
            .limit(10)
            .get())
        .docs;
  }

//fetch next Product list
  Future<List<DocumentSnapshot>> fetchNextProducts(
      CollectionReference collectionReference,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
            .orderBy('name', descending: false)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .get())
        .docs;
  }

  //--------------------------------------------------------------------------
  //fetch fresh from oven
  Future<List<DocumentSnapshot>> fetchFreshFromOven(
      CollectionReference collectionReference) async {
    return (await collectionReference
            .orderBy("name", descending: true)
            .limit(20)
            .get())
        .docs;
  }

  //paginate fresh from oven data
  Future<List<DocumentSnapshot>> fetchNextFreshFromOvenListItems(
      CollectionReference collectionReference,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
            .orderBy('name', descending: true)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(20)
            .get())
        .docs;
  }

//------------------------END-------------------------------------------

  //fetch category........................................................
  Future<List<DocumentSnapshot>> fetchCategoryList(
      CollectionReference collectionReference, String category) async {
    return (await collectionReference
            .orderBy("name", descending: false)
            .where('category', isEqualTo: category)
            .limit(10)
            .get())
        .docs;
  }

  //paginate category data
  Future<List<DocumentSnapshot>> fetchNextCategoryListItems(
      CollectionReference collectionReference,
      String category,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
            .orderBy('name', descending: false)
            .where('category', isEqualTo: category)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .get())
        .docs;
  }

  //...........................END.............................................//

  //fetch users ORDERS
  Future<List<DocumentSnapshot>> fetchOrders(
      CollectionReference collectionReference) async {
    return (await collectionReference
            .orderBy("timestamp", descending: true)
            .where('uid', isEqualTo: currentUserId)
            .limit(20)
            .get())
        .docs;
  }

  //paginate orders data
  Future<List<DocumentSnapshot>> fetchNextOrderListItems(
      CollectionReference collectionReference,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
            .orderBy("timestamp", descending: true)
            .where('uid', isEqualTo: currentUserId)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(20)
            .get())
        .docs;
  }

//admin
  Future<List<DocumentSnapshot>> fetchAllOrders(
      CollectionReference collectionReference) async {
    return (await collectionReference
            .orderBy("timestamp", descending: true)
            .limit(20)
            .get())
        .docs;
  }

  //paginate orders data
  Future<List<DocumentSnapshot>> fetchNextAllOrderListItems(
      CollectionReference collectionReference,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
            .orderBy("timestamp", descending: true)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(20)
            .get())
        .docs;
  }
}
