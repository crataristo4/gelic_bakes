import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';

class OnboardingSlideItem extends StatelessWidget {
  final image, title, content;
  final reverse;

  const OnboardingSlideItem(
      {Key? key, this.image, this.title, this.content, this.reverse = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: tenDp, right: tenDp, bottom: hundredDp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !reverse
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: threeHundredDp,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(thirtyDp),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: AssetImage(image))),
                      ),
                    ),
                    SizedBox(
                      height: twentyDp,
                    ),
                  ],
                )
              : SizedBox(),
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: thirtyDp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: tenDp,
          ),
          Center(
            child: Text(
              content,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: sixteenDp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          reverse
              ? Column(
                  children: [
                    SizedBox(
                      height: twentyDp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(thirtyDp),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: AssetImage(image))),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
