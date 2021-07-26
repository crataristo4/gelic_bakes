import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/datasource/pastry_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/product.dart';
import 'package:gelic_bakes/ui/bottomsheets/pre_order.dart';
import 'package:gelic_bakes/ui/pages/orders.dart';

class CategoryItems extends StatefulWidget {
  static const routeName = '/categoryItem';
  final category;

  const CategoryItems({Key? key, this.category}) : super(key: key);

  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  ProductListBloc? _productList;
  CollectionReference _productRef =
      FirebaseFirestore.instance.collection("Product");
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // controller.addListener(_scrollListener);
    super.initState();
    _productList = ProductListBloc();
    if (widget.category.toString().isEmpty) {
      _productList!.fetchProducts(_productRef);
    } else {
      _productList!.fetchCategoryList(_productRef, widget.category);
    }
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        widget.category.toString().isEmpty) {
      _productList!.fetchNextProducts(_productRef);
    }
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        widget.category.toString().isNotEmpty) {
      _productList!.fetchNextCategoryListItems(_productRef, widget.category);
    }
  }

  @override
  void dispose() {
    _productList!.dispose();
    super.dispose();
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
          widget.category.toString().isEmpty ? allPastries : widget.category,
          style: TextStyle(color: Colors.pink),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(UsersOrdersPage.routeName, arguments: true);
              },
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
              itemBuilder: (context, index) {
                Product product = Product.fromSnapshot(snapshot.data![index]);
                return Container(
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Positioned(
                        top: thirtyDp,
                        left: fourteenDp,
                        right: eightDp,
                        child: Container(
                          // margin: EdgeInsets.only(left: 14),
                          width: MediaQuery.of(context).size.width,
                          height: oneTwentyDp,
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
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: sixtyDp, left: sixteenDp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(eightDp),
                        ),

                        //contains the image of product
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(eightDp),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            width: oneThirtyDp,
                            height: oneTwentyDp,
                            imageUrl: product.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: oneSixtyDp,
                        top: fortyDp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  twoHundredDp,
                              child: Text(
                                //item name
                                product.name!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fourteenDp),
                              ),
                            ),
                            SizedBox(
                              //item description
                              width: MediaQuery.of(context).size.width -
                                  twoHundredDp,
                              child: Text(
                                //item name
                                product.description!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    color: Colors.black, fontSize: fourteenDp),
                              ),
                            ),
                            SizedBox(
                              height: tenDp,
                            ),
                            Row(
                              children: [
                                Text(
                                  //item price
                                  "$kGhanaCedi ${product.price}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: fourteenDp),
                                ),
                                SizedBox(
                                  width: sixtyDp,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => PreOrder(
                                          product: product,
                                            ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: eightDp, bottom: eightDp),
                                    margin: EdgeInsets.only(right: eightDp),
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
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              controller: controller,
              physics: ClampingScrollPhysics(),
            );
          }),
    );
  }
}
