import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/product.dart';

class DetailsPage extends StatefulWidget {
  static const routeName = '/detailsPage';
  final Product? product;

  const DetailsPage({Key? key, this.product}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF757575),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(twentyDp),
                topRight: Radius.circular(twentyDp))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                ),
                Text(
                  "Details",
                  style: TextStyle(color: Colors.pink, fontSize: twentyDp),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: eightDp,
              ),
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
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  imageUrl: "${widget.product!.image!}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: eightDp, top: eightDp),
              child: Text(
                "Item name",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: eightDp, vertical: sixDp),
              child: Text(
                "${widget.product!.name}",
                style: TextStyle(
                    fontSize: sixteenDp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Divider(
              height: 1,
              indent: eightDp,
              endIndent: eightDp,
            ),
            widget.product!.description!.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: eightDp, top: eightDp),
                    child: Text(
                      "Item description",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
            widget.product!.description!.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: eightDp, top: eightDp),
                    child: Text(
                      "${widget.product!.description}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
