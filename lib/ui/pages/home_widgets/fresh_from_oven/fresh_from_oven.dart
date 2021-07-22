import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/datasource/pastry_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/pastry.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/fresh_from_oven/view_all_fresh_from_oven.dart';

class FreshFromOven extends StatefulWidget {
  const FreshFromOven({Key? key}) : super(key: key);

  @override
  _FreshFromOvenState createState() => _FreshFromOvenState();
}

class _FreshFromOvenState extends State<FreshFromOven> {
  PastryListBloc? _pastryList;
  CollectionReference _freshFromOvenRef =
      FirebaseFirestore.instance.collection("Fresh");

  @override
  void initState() {
    _pastryList = PastryListBloc();
    _pastryList!.fetchFreshFromOven(_freshFromOvenRef);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: twoFiftyDp,
      margin: EdgeInsets.only(left: fiftyDp),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: sixDp),
                child: Text(freshFromOven,
                    style: TextStyle(
                        color: Colors.pink,
                        fontSize: twentyDp,
                        fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ViewAllFreshFromOven.routeName);
                },
                child: Container(
                  padding: EdgeInsets.only(top: eightDp, bottom: eightDp),
                  margin: EdgeInsets.only(right: eightDp),
                  child: Center(
                      child: Text(
                    viewAll,
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(eightyDp),
                      color: Colors.pinkAccent),
                  height: thirtyDp,
                  width: hundredDp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: sixteenDp,
          ),
          Expanded(flex: 1, child: buildItemList())
        ],
      ),
    );
  }

  Widget buildItemList() {
    return StreamBuilder<List<DocumentSnapshot>>(
        stream: _pastryList!.itemListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error occurred during loading"),
            );
          }
          return ListView.builder(
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Pastry freshFromOven =
                  Pastry.freshFromOven(snapshot.data![index]);
              return Container(
                width: twoFiftyDp,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: sixteenDp,
                      child: Container(
                        margin: EdgeInsets.all(tenDp),
                        width: twoTwentyDp,
                        height: oneSixtyDp,
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(eightDp)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: fourDp,
                              bottom: tenDp,
                              right: fourDp,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: eightDp),
                                      child: Text(
                                        //item name
                                        freshFromOven.name!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: fourteenDp),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: eightDp,
                                      ),
                                      child: Text(
                                        //item price
                                        "$kGhanaCedi ${freshFromOven.price}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: fourteenDp),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: eightDp, top: fourDp),
                                      child: Text(
                                        "${freshFromOven.category}",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: twelveDp,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),

                                    //pre order
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: eightDp, bottom: eightDp),
                                      margin: EdgeInsets.only(
                                          right: sixDp, top: fourDp),
                                      child: Center(
                                          child: Text(
                                        preOrder,
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(eightyDp),
                                          color: Colors.pinkAccent),
                                      height: thirtyDp,
                                      width: hundredDp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(eightDp),
                      ),

                      //contains the image of product
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(eightDp),
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          width: oneFiftyDp,
                          height: oneTwentyDp,
                          imageUrl: freshFromOven.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
          );
        });
  }
}
