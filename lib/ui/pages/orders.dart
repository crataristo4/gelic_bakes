import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/datasource/pastry_bloc.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class OrdersPage extends StatefulWidget with NavigationState {
  static const routeName = '/orderPage';

  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  PastryListBloc? _pastryList;
  CollectionReference _pastryRef =
      FirebaseFirestore.instance.collection("Orders");
  ScrollController controller = ScrollController();

  @override
  void initState() {
    _pastryList = PastryListBloc();
    _pastryList!.fetchOrders(_pastryRef);
    controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      _pastryList!.fetchNextOrderListItems(_pastryRef);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _pastryList!.itemListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Orders orders = Orders.fromSnapshot(snapshot.data![index]);
                return Card(
                  elevation: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: fortyDp,
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
                                  Text(
                                      "Ordered ${timeAgo.format(orders.timestamp.toDate())}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black45,
                                      )),
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
                );
              },
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            );
          }),
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
}
