import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/promotion.dart';
import 'package:gelic_bakes/provider/promo_provider.dart';
import 'package:gelic_bakes/ui/bottomsheets/pre_order.dart';
import 'package:provider/provider.dart';
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
  /*CollectionReference _promotionRef =
      FirebaseFirestore.instance.collection("Special Offers");
  ScrollController controller = ScrollController();
  ProductListBloc? _productList;*/
  PromoProvider _promoProvider = PromoProvider();
  CountdownTimerController? countDownController;
  dynamic endTime;
  List<Promotion>? promoList, promos;

  @override
  void initState() {
    /*   _productList = ProductListBloc();
    _productList!.fetchPromotion(_promotionRef, widget.category);
    controller.addListener(_scrollListener);*/

    /*  promos = Provider.of<List<Promotion>>(context,listen:false);
    promoList = promos!
        .where((Promotion promotion) => widget.category == promotion.category)
        .toList();*/

    super.initState();
  }

  end(String promoId) {
    _promoProvider.updatePromo(promoId, context);
  }

  @override
  void didUpdateWidget(covariant ViewSpecialOffers oldWidget) {
    if (oldWidget.key.toString() == "btn") {
      print(oldWidget.key);
    }
    super.didUpdateWidget(oldWidget);
  }

/*
  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange)
      _productList!.fetchNextPromotion(_promotionRef, widget.category);
  }*/

  @override
  void dispose() {
    //_controller!.dispose();
    // _productList!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    promos = Provider.of<List<Promotion>>(context, listen: true);
    promoList = promos!
        .where((Promotion promotion) => widget.category == promotion.category)
        .toList();

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
        body: promoList!.length == 0
            ? Center(
                child: Text(
                  'No Promo available for ${widget.category}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: twentyFourDp),
                ),
              )
            : Card(
                elevation: 0,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    Promotion promotion =
                        Promotion.fromFirestore(promoList![index].toMap());

                    var endDateToMilliSec = DateTime.parse(promotion.endDate!);
                    endTime = endDateToMilliSec.millisecondsSinceEpoch;

                    countDownController =
                        CountdownTimerController(endTime: endTime);

                    return buildPromotion(promotion, promoList![index].id);
                  },
                  itemCount: promoList!.length,
                  shrinkWrap: true,
                  //controller: controller,
                  physics: ClampingScrollPhysics(),
                ),
              ));
  }

  buildCustomTimer(int time, Color bgColor, String timeType) {
    return Container(
      margin: EdgeInsets.only(bottom: eightDp),
      width: eightyDp,
      height: fiftyDp,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(eightDp),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey,
        direction: ShimmerDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$time ",
              style: TextStyle(color: Colors.white, fontSize: sixteenDp),
            ),
            Text(
              timeType,
              style: TextStyle(color: Colors.white, fontSize: sixteenDp),
            ),
          ],
        ),
      ),
    );
  }

  buildPromotion(Promotion promotion, String id) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: tenDp,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      ShowImageScreen(image: promotion.image),
                  opaque: false));
            },
            child: Container(
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
          SizedBox(
            height: tenDp,
          ),
          Divider(
            height: 1,
            indent: 1,
            endIndent: 1,
          ),
          SizedBox(
            height: tenDp,
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
                        key: Key("btn"),
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
          ),
          SizedBox(
            height: tenDp,
          ),
          CountdownTimer(
            endTime: endTime,
            controller: countDownController,
            widgetBuilder: (_, CurrentRemainingTime? time) {
              if (time == null) {
                end(id);
                return Center(
                  child: Text(
                    'Offer Ended',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: twentyFourDp),
                  ),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ENDS',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  time.days == null
                      ? Container()
                      : buildCustomTimer(time.days!, Colors.black,
                          time.days! > 1 ? 'days' : 'day'),
                  time.hours == null
                      ? Container()
                      : buildCustomTimer(time.hours!, Colors.blue,
                          time.hours! > 1 ? 'hrs' : 'hr'),
                  time.min == null
                      ? Container()
                      : buildCustomTimer(time.min!, Colors.brown,
                          time.min! > 1 ? 'mins' : 'min'),
                  time.sec == null
                      ? Container()
                      : buildCustomTimer(time.sec!, Colors.red, "sec"),
                ],
              );
            },
          ),
          SizedBox(
            height: tenDp,
          ),
        ],
      ),
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
