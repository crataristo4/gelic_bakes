import 'package:flutter/cupertino.dart';
import 'package:gelic_bakes/models/reviews.dart';
import 'package:gelic_bakes/service/review_service.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/pages/acount_page.dart';

class ReviewProvider with ChangeNotifier {
  ReviewService reviewService = ReviewService();
  final DateTime timestamp = DateTime.now();

  String? message;

  get _message => message;

  setMessage(value) {
    message = value;
    notifyListeners();
  }

  createReview(BuildContext context) {
    Reviews reviews = Reviews(
        id: currentUserId,
        name: AccountPage.userName,
        image: AccountPage.userImage,
        message: _message,
        timestamp: timestamp);

    reviewService.createReview(reviews, context);
  }
}
