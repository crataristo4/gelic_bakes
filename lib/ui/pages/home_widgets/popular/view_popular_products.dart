import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/datasource/product_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/product.dart';
import 'package:gelic_bakes/ui/bottomsheets/pre_order.dart';

class ViewAllPopularProduct extends StatefulWidget {
  static const routeName = '/viewAllPopularProduct';

  const ViewAllPopularProduct({Key? key}) : super(key: key);

  @override
  _ViewAllPopularProductState createState() => _ViewAllPopularProductState();
}

class _ViewAllPopularProductState extends State<ViewAllPopularProduct> {
  ProductListBloc? _productList;
  CollectionReference _productRef =
      FirebaseFirestore.instance.collection("Fresh");
  ScrollController controller = ScrollController();

  @override
  void initState() {
    _productList = ProductListBloc();
    _productList!.fetchPopularProduct(_productRef);
    controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      _productList!.fetchNextPopularProductListItems(_productRef);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
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
        ),
        title: Text(
          popularProduct,
          style: TextStyle(color: Colors.pink),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.pink,
              ))
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _productList!.itemListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              addAutomaticKeepAlives: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Product PopularProduct =
                    Product.PopularProduct(snapshot.data![index]);
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: twoTwentyDp,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Positioned(
                        top: thirtyDp,
                        left: tenDp,
                        right: tenDp,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: eightDp,
                                        ),
                                        child: Text(
                                          //item name
                                          PopularProduct.name!,
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
                                          "$kGhanaCedi ${PopularProduct.price}",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: eightDp, top: fourDp),
                                        child: Text(
                                          "${PopularProduct.category}",
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
                                                    product: PopularProduct,
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      eightyDp),
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
                        margin: EdgeInsets.symmetric(horizontal: tenDp),

                        //contains the image of product
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(eightDp),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            width: oneFiftyDp,
                            height: oneTwentyDp,
                            imageUrl: PopularProduct.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: snapshot.data!.length,
              //  scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              controller: controller,
            );
          }),
    );
  }
}
