import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/models/promotion.dart';

class PromoService {
  final firestoreService = FirebaseFirestore.instance;

  //update promo
  Future<void> updatePromo(BuildContext context, String promoId) async {
    return await firestoreService
        .collection('Promo')
        .doc(promoId)
        .update({"isEnded": true}).catchError((onError) {});
  }

  //get all promos from db
  Stream<List<Promotion>> getPromos() {
    return firestoreService
        .collection('Promo')
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Promotion.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }
}
