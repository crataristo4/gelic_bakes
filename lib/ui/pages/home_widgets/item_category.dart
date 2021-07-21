import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';

class CategoryItems extends StatefulWidget {
  static const routeName = '/categoryItem';
  final name;

  const CategoryItems({Key? key, this.name}) : super(key: key);

  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
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
          widget.name,
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
      body: ListView.builder(
        itemBuilder: (context, index) {
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
                    height: hundredDp,
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
                  margin: EdgeInsets.only(bottom: sixtyDp, left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(eightDp),
                  ),

                  //contains the image of product
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(eightDp),
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      width: oneThirtyDp,
                      height: oneTwentyDp,
                      imageUrl: '',
                    ),
                  ),
                ),
                Positioned(
                  left: oneSixtyDp,
                  top: fiftyDp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //item name
                        "item name",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: fourteenDp),
                      ),
                      SizedBox(
                        height: tenDp,
                      ),
                      Row(
                        children: [
                          Text(
                            //item name
                            "$kGhanaCedi 250",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: fourteenDp),
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: eightDp, bottom: eightDp),
                            margin: EdgeInsets.only(right: eightDp),
                            child: Center(
                                child: Text(
                              buyNow,
                              style: TextStyle(color: Colors.white),
                            )),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(eightyDp),
                                color: Colors.pinkAccent),
                            height: thirtyDp,
                            width: hundredDp,
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
        itemCount: 20,
        shrinkWrap: true,
      ),
    );
  }
}
