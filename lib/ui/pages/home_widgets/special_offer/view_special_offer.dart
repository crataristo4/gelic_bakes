import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/datasource/product_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/promotion.dart';
import 'package:gelic_bakes/ui/bottomsheets/pre_order.dart';
import 'package:gelic_bakes/ui/widgets/loading.dart';

class ViewSpecialOffers extends StatefulWidget {
  static const routeName = '/viewSpecialOffer';
  final category;

  const ViewSpecialOffers({Key? key, this.category}) : super(key: key);

  @override
  _ViewSpecialOffersState createState() => _ViewSpecialOffersState();
}

class _ViewSpecialOffersState extends State<ViewSpecialOffers> {
  CollectionReference _promotionRef =
      FirebaseFirestore.instance.collection("Special Offers");
  ScrollController controller = ScrollController();
  ProductListBloc? _productList;

  @override
  void initState() {
    _productList = ProductListBloc();
    _productList!.fetchPromotion(_promotionRef, widget.category);
    controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange)
      _productList!.fetchNextPromotion(_promotionRef, widget.category);
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
          'Promo for ${widget.category}',
          style: TextStyle(color: Colors.pink, fontSize: sixteenDp),
        ),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _productList!.itemListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingShimmer(
                category: widget.category,
              );
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                print(snapshot.data);
                Promotion promotion =
                    Promotion.fromSnapshot(snapshot.data![index]);
                return buildPromotion(promotion);
              },
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              controller: controller,
              physics: ClampingScrollPhysics(),
            );
          }),
    );
  }

  buildPromotion(Promotion promotion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              imageUrl: "${promotion.image!}",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: eightDp, vertical: sixDp),
                child: Text(
                  "${promotion.name}",
                  style: TextStyle(
                      fontSize: sixteenDp,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: eightDp, vertical: sixDp),
              child: Text(
                "Priced @ $kGhanaCedi${promotion.price}",
                style: TextStyle(
                    fontSize: sixteenDp,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
        Divider(
          height: 1,
          indent: eightDp,
          endIndent: eightDp,
        ),
        promotion.description!.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: eightDp, top: eightDp),
                child: Text(
                  "Promo description",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
        promotion.description!.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: eightDp, top: fourDp),
                child: Text(
                  "${promotion.description}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
              ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (context) => PreOrder.promo(
                      promotion: promotion,
                    ));
          },
          child: Container(
            padding: EdgeInsets.only(top: eightDp, bottom: eightDp),
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
        ),
      ],
    );
  }
}

//Display full image
class ShowImageScreen extends StatelessWidget {
  final image;

  const ShowImageScreen({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            //  color: const Color(0xff7c94b6),
            color: Colors.black45,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.colorDodge),
              image: CachedNetworkImageProvider(
                image!,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: tenDp),
        ),
      ),
    );
  }
}
