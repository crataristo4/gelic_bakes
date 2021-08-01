import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gelic_bakes/bloc/datasource/product_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/promotion.dart';
import 'package:gelic_bakes/ui/bottomsheets/pre_order.dart';
import 'package:gelic_bakes/ui/widgets/loading.dart';
import 'package:shimmer/shimmer.dart';

class ViewSpecialOffers extends StatefulWidget {
  static const routeName = '/viewSpecialOffer';
  final category;

  const ViewSpecialOffers({Key? key, this.category}) : super(key: key);

  @override
  _ViewSpecialOffersState createState() => _ViewSpecialOffersState();
}

class _ViewSpecialOffersState extends State<ViewSpecialOffers>
    with TickerProviderStateMixin {
  CollectionReference _promotionRef =
      FirebaseFirestore.instance.collection("Special Offers");
  ScrollController controller = ScrollController();
  ProductListBloc? _productList;
  CountdownTimerController? countDownController;
  dynamic endTime;

  /* AnimationController? _controller;
  int levelClock = 180;*/

  @override
  void initState() {
    _productList = ProductListBloc();
    _productList!.fetchPromotion(_promotionRef, widget.category);
    controller.addListener(_scrollListener);

    /*   _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
    );

    _controller!.forward();*/
    super.initState();
  }

  void end() {
    print('onEnd');
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange)
      _productList!.fetchNextPromotion(_promotionRef, widget.category);
  }

  @override
  void dispose() {
    //_controller!.dispose();
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
                Promotion promotion =
                    Promotion.fromSnapshot(snapshot.data![index]);

                var endDateToMilliSec = DateTime.parse(promotion.endDate!);
                endTime = endDateToMilliSec.millisecondsSinceEpoch;

                countDownController =
                    CountdownTimerController(endTime: endTime, onEnd: end);

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
        Divider(
          height: 1,
          indent: 1,
          endIndent: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: eightDp, vertical: sixDp),
              child: Text(
                "Priced @ $kGhanaCedi${promotion.price}",
                style: TextStyle(
                    decoration: promotion.discountPrice! == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                    fontSize: sixteenDp,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            ),
            promotion.discountPrice! == 0
                ? Container()
                : Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: eightDp, vertical: sixDp),
                      child: Text(
                        "Now $kGhanaCedi${promotion.discountPrice}",
                        style: TextStyle(
                            fontSize: sixteenDp,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
            promotion.isEnded!
                ? Container()
                : GestureDetector(
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

            /*Countdown(
              animation: StepTween(
                begin: levelClock, // THIS IS A USER ENTERED NUMBER
                end: 0,
              ).animate(_controller!),
            ),*/
          ],
        ),
        Center(
          child: CountdownTimer(
            endTime: endTime,
            widgetBuilder: (_, CurrentRemainingTime? time) {
              return time == null
                  ? Center(
                      child: Text(
                        'Offer Ended',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: twentyFourDp),
                      ),
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.pink,
                      highlightColor: Colors.blue,
                      direction: ShimmerDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: eightDp),
                            child: Text(
                              'Offer ends in',
                              style: TextStyle(
                                  color: Colors.black, fontSize: twentyDp),
                            ),
                          ),
                          time.days == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: eightDp),
                                  child: Text(
                                    time.days! > 1
                                        ? '${time.days} days'
                                        : '${time.days} day',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: twentyDp),
                                  ),
                                ),
                          time.hours == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: eightDp),
                                  child: Text(
                                    time.hours! > 1
                                        ? '${time.hours} hrs'
                                        : '${time.hours} hr',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: twentyDp),
                                  ),
                                ),
                          time.min == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: eightDp),
                                  child: Text(
                                    '${time.min} mins',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: twentyDp),
                                  ),
                                ),
                          time.sec == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: eightDp),
                                  child: Text(
                                    '${time.sec} secs',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: twentyDp),
                                  ),
                                ),
                        ],
                      ),
                    );
            },
            onEnd: end,
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

/*//count down
class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation}) : super(key: key, listenable: animation!);
  Animation<int>? animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation!.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 110,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}*/
