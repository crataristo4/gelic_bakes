import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelic_bakes/bloc/datasource/pastry_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:gelic_bakes/provider/orders_provider.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:timeago/timeago.dart' as timeAgo;

///fOR ADMIN
class OrdersPage extends StatefulWidget {
  static const routeName = '/orderPageAdmin';

  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  ProductListBloc? _productList;
  CollectionReference _productRef =
      FirebaseFirestore.instance.collection("Orders");
  ScrollController controller = ScrollController();
  OrdersProvider ordersProvider = OrdersProvider();
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //choose set delivery or payment status
  void _showPicker(context, itemId) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.delivery_dining,
                        color: Colors.indigo,
                      ),
                      title: Text(setDeliveryFee,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.pink)),
                      onTap: () {
                        Navigator.of(context).pop();
                        ShowAction.showAlertDialog(
                            setDeliveryFee,
                            abtToSetDeliveryFee,
                            context,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Container(
                                    width: hundredDp,
                                    height: fortyEightDp,
                                    child: TextFormField(
                                        autovalidate: true,
                                        validator: (value) => value!.length > 0
                                            ? null
                                            : 'invalid fee',
                                        keyboardType: TextInputType.number,
                                        controller: _controller,
                                        onChanged: (value) {},
                                        maxLengthEnforcement:
                                            MaxLengthEnforcement.enforced,
                                        decoration: InputDecoration(
                                          hintText: 'Delivery fee',
                                          fillColor: Color(0xFFF5F5F5),
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: fourDp),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF5F5F5))),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF5F5F5))),
                                        )),
                                  ),
                                ),
                                TextButton(
                                  child: Text(
                                    yesSet,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      ordersProvider.setDelivery(int.parse(
                                          "${_controller.text.toString()}"));
                                      ordersProvider.updateDeliveryFee(
                                          itemId, context);
                                    } else {
                                      ShowAction().showToast(
                                          "Delivery fee required", Colors.red);
                                    }
                                  },
                                ),
                              ],
                            ),
                            TextButton(
                              child: Text(
                                cancel,
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ));
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.money,
                      color: Colors.green,
                    ),
                    title: Text(
                      setPaymentStatus,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      ShowAction.showAlertDialog(
                          setPaymentStatus,
                          youAreAbtTpSetPaymentStatus,
                          context,
                          TextButton(
                            child: Text(
                              yes,
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () {
                              ordersProvider.updatePaidOrder(itemId, context);
                            },
                          ),
                          TextButton(
                            child: Text(
                              cancel,
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ));
                    },
                  ),
                  /* ListTile(
                    leading: Icon(
                      Icons.map,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      viewLocation,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                    },
                  ),*/
                ],
              ),
            ),
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _productList = ProductListBloc();
    _productList!.fetchAllOrders(_productRef);
    controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      _productList!.fetchNextAllOrderListItems(_productRef);
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
          stream: _productList!.itemListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Orders orders = Orders.fromSnapshot(snapshot.data![index]);

                return GestureDetector(
                  onTap: () async {
                    //CONFIRM DELIVERY FEE and payment status
                    _showPicker(context, snapshot.data![index].id);
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: tenDp,
                              top: tenDp,
                              bottom: tenDp,
                              right: eightDp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(eightDp),
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
                                          width: sixtyDp,
                                        ),
                                        orders.isPaid!
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : Container()
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
                        Container(
                          margin: EdgeInsets.symmetric(vertical: tenDp),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton(
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  mini: true,
                                  onPressed: () {
                                    SnackBar snackBar = SnackBar(
                                        padding: EdgeInsets.all(tenDp),
                                        duration: Duration(seconds: 5),
                                        action: SnackBarAction(
                                          label: 'Yes',
                                          onPressed: () {
                                            ShowAction.makePhoneCall(
                                                'tel:${orders.phoneNumber}');
                                          },
                                          textColor: Colors.white,
                                        ),
                                        backgroundColor: Colors.pink,
                                        content: Text(
                                          'Do you want to Call ${orders.name} now ?',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                ),
                                FloatingActionButton(
                                  child: Icon(
                                    Icons.map,
                                    color: Colors.white,
                                  ),
                                  mini: true,
                                  onPressed: () async {
                                    final availableMaps =
                                        await MapLauncher.installedMaps;

                                    await availableMaps.first.showMarker(
                                      coords: Coords(orders.location!.latitude,
                                          orders.location!.longitude),
                                      title: '${orders.name}\'s location',
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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
