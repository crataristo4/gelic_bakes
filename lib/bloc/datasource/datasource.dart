import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataProvider {
  //fetch all pastries ---------------------------------------------------------------//
  Future<List<DocumentSnapshot>> fetchAllPastries(
      CollectionReference collectionReference) async {
    return (await collectionReference
            .orderBy("name", descending: false)
            .limit(20)
            .get())
        .docs;
  }

//fetch next pastry list
  Future<List<DocumentSnapshot>> fetchNextPastryListItems(
      CollectionReference collectionReference,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
            .orderBy('name', descending: false)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(20)
            .get())
        .docs;
  }

  //--------------------------------------------------------------------------
  //fetch fresh from oven
  Future<List<DocumentSnapshot>> fetchFreshFromOven(
      CollectionReference collectionReference) async {
    return (await collectionReference
            .orderBy("name", descending: false)
            .limit(20)
            .get())
        .docs;
  }

  //paginate fresh from oven data
  Future<List<DocumentSnapshot>> fetchNextFreshFromOvenListItems(
      CollectionReference collectionReference,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
            .orderBy('name', descending: false)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(20)
            .get())
        .docs;
  }

//------------------------END-------------------------------------------

  //fetch category
  Future<List<DocumentSnapshot>> fetchCategoryList(
      CollectionReference collectionReference, String category) async {
    return (await collectionReference
            .orderBy("name", descending: false)
            .where('category', isEqualTo: category)
            .limit(20)
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
            .limit(20)
            .get())
        .docs;
  }
}
