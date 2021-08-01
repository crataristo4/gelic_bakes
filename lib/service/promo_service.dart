import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PromoService {
  final firestoreService = FirebaseFirestore.instance;

  //update promo
  Future<void> updatePromo(BuildContext context, String promoId) {
    return firestoreService
        .collection('Special Offers')
        .doc(promoId)
        .update({"isEnded": true}).catchError((onError) {});
  }
}
