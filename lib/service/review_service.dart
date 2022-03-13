import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/reviews.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';

class ReviewService {
  final firestoreService = FirebaseFirestore.instance;

  //create history
  Future<void> createReview(Reviews reviews, BuildContext context) {
    return firestoreService
        .collection('Reviews')
        .add(reviews.reviewToMap())
        .whenComplete(() {
      showSuccess(context);
    }).catchError((error) {
      showFailure(context, error);
    });
  }

  //get all reviews from db
  Stream<List<Reviews>> getAllReviews() {
    return firestoreService
        .collection('Reviews')
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Reviews.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }

  //get all reviews from db
  Stream<List<Reviews>> getReviewsById() {
    return firestoreService
        .collection('Reviews')
        .where("id", isEqualTo: currentUserId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Reviews.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }

  showSuccess(context) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop();

    /* Navigator.of(context)
        .pushReplacementNamed(ReviewsPage.routeName, arguments: false);*/
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
