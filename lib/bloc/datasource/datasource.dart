import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataProvider {
  //fetch fresh from oven
  Future<List<DocumentSnapshot>> fetchFreshFromOven(
      CollectionReference collectionReference) async {
    return (await collectionReference
            .orderBy("name", descending: true)
            .limit(20)
            .get())
        .docs;
  }

  //fetch category
  Future<List<DocumentSnapshot>> fetchFirstList(
      CollectionReference collectionReference, String category) async {
    return (await collectionReference
            .orderBy("name", descending: true)
            .where('category', isEqualTo: category)
            .limit(20)
            .get())
        .docs;
  }

  //paginate category data
  Future<List<DocumentSnapshot>> fetchNextList(CollectionReference collectionReference,
      String category,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
        .orderBy('name', descending: true)
        .where('category', isEqualTo: category)
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(20)
        .get())
        .docs;
  }
}
