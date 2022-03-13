import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/service/admob_service.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/category/item_category.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

class Category extends StatelessWidget {
  const Category({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: sixDp, left: sixteenDp),
                child: Text(browseByCategory,
                    style: TextStyle(
                        color: Colors.pink,
                        fontSize: twentyDp,
                        fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context)
                      .pushNamed(CategoryItems.routeName, arguments: '');
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
            height: tenDp,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: sixteenDp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildItemCategory(context, 'assets/images/cake.jpg', cake),
                buildItemCategory(context, 'assets/images/chips.jpg', chips),
                buildItemCategory(context, 'assets/images/cookie.jpg', cookies),
                buildItemCategory(
                    context, 'assets/images/doughnut.jpg', doughnut),
                buildItemCategory(context, 'assets/images/pie.jpg', pie),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: thirtyDp, left: sixteenDp),
                child: Text(weAlsoHave,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: sixteenDp,
                        fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context)
                      .pushNamed(CategoryItems.routeName, arguments: 'Drugs');
                },
                child: Container(
                  padding: EdgeInsets.only(top: eightDp, bottom: eightDp),
                  margin: EdgeInsets.only(right: eightDp, top: twentyDp),
                  child: Center(
                      child: Text(
                    viewAll,
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(eightyDp),
                      color: Colors.black),
                  height: thirtyDp,
                  width: hundredDp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: tenDp,
          ),
          // Container(
          //   margin: EdgeInsets.only(bottom: sixDp),
          //   height: sixtyDp,
          //   child: AdWidget(
          //     ad: AdmobService.createBannerSmall()..load(),
          //     key: UniqueKey(),
          //   ),
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: tenDp, left: sixteenDp),
                child: Text(youMayAlsoLike,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: sixteenDp,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: tenDp,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: sixteenDp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildItemCategory(context, 'assets/images/fj.jpg', fruitDrinks),
                buildItemCategory(context, 'assets/images/shoe.jpg', shoes),
                buildItemCategory(context, 'assets/images/wig.jpg', wigs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemCategory(context, image, String category) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context)
            .pushNamed(CategoryItems.routeName, arguments: category);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: sixtyDp,
            height: sixtyDp,
            decoration: BoxDecoration(
                borderRadius: category == vaginne ||
                        category == adwelle ||
                        category == vtide
                    ? BorderRadius.circular(tenDp)
                    : BorderRadius.circular(thirtyTwoDp),
                border: category == vaginne ||
                        category == adwelle ||
                        category == vtide
                    ? Border.all(color: Colors.pink, width: 0.3)
                    : Border.all(color: Colors.white, width: 0.3),
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: eightDp),
            child:
                category == vaginne || category == adwelle || category == vtide
                    ? Text(
                        category,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3),
                      )
                    : Text(category),
          )
        ],
      ),
    );
  }

/*Widget buildImmeriProducts(context, image, category) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context)
            .pushNamed(CategoryItems.routeName, arguments: category);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: sixtyDp,
            height: sixtyDp,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.pink, width: 0.3),
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: eightDp),
            child: Text(
              category,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3),
            ),
          )
        ],
      ),
    );
  }*/
}
