import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/ui/pages/home_widgets/category/item_category.dart';

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
            margin: EdgeInsets.symmetric(horizontal: 16),
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
        ],
      ),
    );
  }

  Widget buildItemCategory(context, image, category) {
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
                borderRadius: BorderRadius.circular(thirtyTwoDp),
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: eightDp),
            child: Text(category),
          )
        ],
      ),
    );
  }
}