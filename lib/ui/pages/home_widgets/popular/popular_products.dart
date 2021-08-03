import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/datasource/product_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/product.dart';
import 'package:gelic_bakes/ui/bottomsheets/pre_order.dart';

class PopularProduct extends StatefulWidget {
  const PopularProduct({Key? key}) : super(key: key);

  @override
  _PopularProductState createState() => _PopularProductState();
}

class _PopularProductState extends State<PopularProduct> {
  ProductListBloc? _productList;
  CollectionReference _popularProductRef =
      FirebaseFirestore.instance.collection("Popular");

  @override
  void initState() {
    _productList = ProductListBloc();
    _productList!.fetchPopularProduct(_popularProductRef);
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
                child: Text(popularProduct,
                    style: TextStyle(
                        color: Colors.pink,
                        fontSize: twentyDp,
                        fontWeight: FontWeight.bold)),
              ),
              /*GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ViewAllPopularProduct.routeName);
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
              ),*/
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
        stream: _productList!.itemListStream,
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
              Product popularProduct =
                  Product.PopularProduct(snapshot.data![index]);
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
                                        popularProduct.name!,
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
                                        "$kGhanaCedi ${popularProduct.price}",
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
                                        "${popularProduct.category}",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: twelveDp,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),

                                    //pre order
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) => PreOrder(
                                                  product: popularProduct,
                                                ));
                                      },
                                      child: Container(
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
                          imageUrl: popularProduct.image!,
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
