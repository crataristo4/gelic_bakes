import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/special_offer/view_special_offer.dart';

class SpecialOffers extends StatefulWidget {
  const SpecialOffers({Key? key}) : super(key: key);

  @override
  _SpecialOffersState createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: sixDp, left: sixteenDp),
              child: Text(specialOffer,
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: twentyDp,
                      fontWeight: FontWeight.bold)),
            ),
            /* Container(
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
            ),*/
          ],
        ),
        SizedBox(
          height: tenDp,
        ),
        // buildTopBakes(),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSpecialOffer(cakeDigest, '🧁'),
              buildSpecialOffer(bananaMiniPack, "🍌"),
              buildSpecialOffer(glutenFree, "❤️"),
            ],
          ),
        )
      ],
    );
  }

  Widget buildSpecialOffer(String name, String icon) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context)
            .pushNamed(ViewSpecialOffers.routeName, arguments: name);
        /* SnackBar snackbar = SnackBar(
          content: Text("No offer available"),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);*/
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: sixDp),
        decoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.1),
          borderRadius: BorderRadius.circular(eightDp),
        ),
        height: oneFiftyDp,
        width: oneFiftyDp,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: eightDp),
              child: Text(
                icon,
                style: TextStyle(fontSize: eightyDp, color: Colors.black),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(eightDp),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.pink),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTopBakes() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(tenDp),
                child: CachedNetworkImage(
                  // image
                  height: twoHundredDp,
                  width: MediaQuery.of(context).size.width,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  imageUrl: '',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: eightDp, bottom: fourDp),
                child: Text(
                  cake,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: twentyDp),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: sixteenDp),
                child: Text(
                  "lorem",
                  style: TextStyle(color: Colors.black45),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 3,
    );
  }
}
