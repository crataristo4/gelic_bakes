import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataProvider {
  Future<List<DocumentSnapshot>> fetchFirstList(
      CollectionReference collectionReference, String category) async {
    return (await collectionReference
            .orderBy("name", descending: true)
            .where('category', isEqualTo: category)
            .limit(20)
            .get())
        .docs;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      CollectionReference collectionReference,
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
