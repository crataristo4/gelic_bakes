import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/reviews.dart';
import 'package:gelic_bakes/provider/review_provider.dart';
import 'package:gelic_bakes/ui/bottomsheets/add_review.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class ReviewsPage extends StatefulWidget with NavigationState {
  static const routeName = '/reviewPage';

  // final bool isBack;

  const ReviewsPage({
    Key? key,
  }) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  TextEditingController controller = TextEditingController();
  ReviewProvider reviewProvider = ReviewProvider();

  @override
  Widget build(BuildContext context) {
    final reviewList = Provider.of<List<Reviews>>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          reviews,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        /*leading:
        InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: EdgeInsets.all(tenDp),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3, color: Colors.grey),
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(thirtyDp)),
                  child: Padding(
                    padding: EdgeInsets.all(eightDp),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: sixteenDp,
                    ),
                  ),
                ),
              ),*/
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => AddReviewPage(),
              isDismissible: false);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        mini: true,
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          /*  Reviews reviews =
              Reviews.fromFirestore(reviewList[index].reviewToMap());*/

          return reviewList.isNotEmpty
              ? buildReviewList(reviewList, index)
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
        itemCount: reviewList.length,
      ),
    );
  }

  Widget buildReviewList(List<Reviews> reviewList, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: eightDp, right: eightDp),
            child: CircleAvatar(
              radius: 20,
              foregroundImage:
                  CachedNetworkImageProvider(reviewList[index].image!),
              backgroundColor: Colors.indigo,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      //name
                      reviewList[index].name!,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: sixteenDp),
                    ),
                    Text(timeAgo.format(reviewList[index].timestamp.toDate()),
                        style: TextStyle(
                            color: Colors.black45, fontSize: fourteenDp)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: fourDp, right: eightDp),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: Text(
                    //review
                    reviewList[index].message!,
                    maxLines: 40,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(
                height: tenDp,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: Divider(
                    thickness: 0.1,
                    color: Colors.black45,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
