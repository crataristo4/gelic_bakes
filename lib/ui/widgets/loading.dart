import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatefulWidget {
  final String? category;

  LoadingShimmer({this.category});

  @override
  _LoadingShimmerState createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer> {
  bool isLoading = true;
  Timer? timer;

  @override
  void initState() {
    callTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  callTimer() {
    timer = Timer(Duration(seconds: 5), () {
      if (mounted)
        setState(() {
          isLoading = !isLoading;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey.shade200,
            direction: ShimmerDirection.ltr,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  margin:
                      EdgeInsets.symmetric(horizontal: tenDp, vertical: tenDp),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(tenDp)),
                );
              },
            ),
          ))
        : Column(
            children: [
              SizedBox(
                height: thirtyDp,
              ),
              Text(
                "Oops! No ${widget.category} available",
                style: TextStyle(fontSize: sixteenDp),
              ),
              Center(
                  child: Image.asset(
                "assets/images/noitem.jpg",
                fit: BoxFit.cover,
              )),
            ],
          );
  }
}
