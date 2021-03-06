import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/datasource/product_bloc.dart';
/*import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';*/
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:gelic_bakes/provider/orders_provider.dart';
import 'package:gelic_bakes/service/admob_service.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';
import 'package:gelic_bakes/ui/widgets/loading.dart';
import 'package:gelic_bakes/ui/widgets/progress_dialog.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../../main.dart';

class UsersOrdersPage extends StatefulWidget with NavigationState {
  static const routeName = '/ordersPageUsers';
  final bool isBack;

  const UsersOrdersPage({Key? key, required this.isBack}) : super(key: key);

  @override
  _UsersOrdersPageState createState() => _UsersOrdersPageState();
}

class _UsersOrdersPageState extends State<UsersOrdersPage> {
  final String txref = "orderPayment";
  String? amount, customerName;

  // final String currency = FlutterwaveCurrency.GHS;

  ProductListBloc? _productList;
  CollectionReference _productRef =
      FirebaseFirestore.instance.collection("Orders");
  ScrollController controller = ScrollController();
  OrdersProvider ordersProvider = OrdersProvider();

  @override
  void initState() {
    _productList = ProductListBloc();
    _productList!.fetchOrders(_productRef);
    controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      _productList!.fetchNextOrderListItems(_productRef);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          yourOrders,
          style: TextStyle(color: Colors.pink),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: !widget.isBack
            ? Container()
            : InkWell(
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
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _productList!.itemListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LoadingShimmer(
                  category: 'No orders made!',
                ),
              );
            }

            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Orders orders = Orders.fromSnapshot(snapshot.data![index]);
                amount = "${orders.getTotalPayment()}";
                customerName = orders.name;
                return GestureDetector(
                  onTap: () async {
                    //beginPayment();
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: thirtyTwoDp,
                              top: tenDp,
                              bottom: tenDp,
                              right: eightDp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(eightDp),
                                  color: Colors.black,
                                ),
                                height: hundredDp,
                                width: hundredDp,
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(eightDp),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    imageUrl: "${orders.itemImage}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: tenDp,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            "Ordered ${timeAgo.format(orders.timestamp.toDate())}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black45,
                                            )),
                                        SizedBox(
                                          width: thirtyDp,
                                        ),
                                        orders.isPaid!
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : Container(),
                                        SizedBox(
                                          width: tenDp,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            ShowAction.showAlertDialog(
                                                deleteOrder,
                                                deleteOrderDes,
                                                context,
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(cancel)),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Dialogs.showLoadingDialog(
                                                        context,
                                                        loadingKey,
                                                        deletingOrder,
                                                        Colors.white);
                                                    ordersProvider.deleteOrder(
                                                        snapshot
                                                            .data![index].id,
                                                        context);
                                                  },
                                                  child: Text(delete),
                                                ));
                                          },
                                          child: widget.isBack
                                              ? Container()
                                              : Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: eightDp,
                                    ),
                                    SizedBox(
                                      width: twoHundredDp,
                                      child: Text("${orders.itemName}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black45,
                                          )),
                                    ),
                                    SizedBox(
                                      height: eightDp,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(quantityOrdered,
                                            style: TextStyle(
                                              color: Colors.black45,
                                            )),
                                        SizedBox(
                                          width: fiftyDp,
                                        ),
                                        Text("${orders.quantity}",
                                            style: TextStyle(
                                              color: Colors.black,
                                            )),
                                        SizedBox(
                                          height: eightDp,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: eightDp,
                                    ),
                                    Text("Due on ${orders.orderDate}",
                                        style: TextStyle(
                                          color: Colors.black45,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: eightDp,
                        ),
                        buildTotal(orders),
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              controller: controller,
              addAutomaticKeepAlives: true,
              separatorBuilder: (BuildContext context, int index) {
                return
                  // index % 3 == 0
                  //   ? Container(
                  //       height: sixtyDp,
                  //       child: AdWidget(
                  //         ad: AdmobService.createBannerSmall()..load(),
                  //         key: UniqueKey(),
                  //       ),
                  //     )
                  //   :
                Container();
              },
            );
          }),
      bottomNavigationBar: Container(
        height: 0,//sixtyDp,
        // child: AdWidget(
        //   ad: AdmobService.createBannerSmall()..load(),
        //   key: UniqueKey(),
        // ),
      ),
    );
  }

  buildTotal(Orders orders) {
    return Container(
      height: oneTwentyDp,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.pinkAccent.withOpacity(.1),
          borderRadius: BorderRadius.circular(eightDp)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          items(SubTotal, "$kGhanaCedi  ${orders.totalPrice}"),
          items(deliveryFee, "$kGhanaCedi  ${orders.deliveryFee}"),
          SizedBox(
            height: eightDp,
          ),
          Divider(
            endIndent: tenDp,
            indent: tenDp,
            color: Colors.pink,
            thickness: 1,
          ),
          items(toTAL, "$kGhanaCedi  ${orders.getTotalPayment()}"),
          SizedBox(
            height: sixteenDp,
          ),
        ],
      ),
    );
  }

  Column items(item1, item2) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: tenDp, top: tenDp),
              child: Text(item1),
            ),
            Padding(
              padding: const EdgeInsets.only(right: sixteenDp, top: tenDp),
              child: Text(
                item2,
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        ),
      ],
    );
  }

/*  beginPayment() async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
        context: this.context,
        encryptionKey: "FLWSECK_TEST88cc8fe40d7a",
        publicKey: "FLWPUBK_TEST-57e678a722e89b81efa2fff3676f142e-X",
        currency: this.currency,
        amount: amount!,
        email: "crataristo4@gmail.com",
        fullName: customerName!,
        txRef: this.txref,
        isDebugMode: true,
        phoneNumber: phoneNumber!,
        acceptCardPayment: false,
        acceptUSSDPayment: false,
        acceptAccountPayment: false,
        acceptFrancophoneMobileMoney: false,
        acceptGhanaPayment: true,
        acceptMpesaPayment: false,
        acceptRwandaMoneyPayment: true,
        acceptUgandaPayment: false,
        acceptZambiaPayment: false);

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction. Payment wasn't successful.
        print("Transaction was not completed");
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          // provide value to customer
          print("Transaction  completed");
        } else {
          // check message
          print(response.message);

          // check status
          print(response.status);

          // check processor error
          print(response.data!.processorResponse);
        }
      }
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data!.currency == this.currency &&
        response.data!.amount == this.amount &&
        response.data!.txRef == this.txref;
  }*/
}
