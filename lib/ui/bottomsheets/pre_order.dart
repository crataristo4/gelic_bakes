import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/main/main.dart';
import 'package:gelic_bakes/models/pastry.dart';
import 'package:gelic_bakes/provider/orders_provider.dart';
import 'package:gelic_bakes/ui/widgets/progress_dialog.dart';
import 'package:intl/intl.dart';

class PreOrder extends StatefulWidget {
  static const routeName = '/placeOrder';
  final Pastry pastry;

  const PreOrder({Key? key, required this.pastry}) : super(key: key);

  @override
  _PreOrderState createState() => _PreOrderState();
}

class _PreOrderState extends State<PreOrder> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateTimeController = TextEditingController();
  OrdersProvider _ordersProvider = OrdersProvider();

  //date format
  DateFormat _dateFormat = DateFormat.yMMMMd('en_US').add_jm();
  DateTime _dateTime = DateTime.now();
  String? bookingDateTime;
  int quantity = 1;
  num? initialPrice, subTotal;

  @override
  void initState() {
    initialPrice = widget.pastry.price;
    subTotal = initialPrice;
    super.initState();
  }

  _increment() {
    setState(() {
      quantity++;
      subTotal = quantity * initialPrice!;
    });
  }

  _decrement() {
    if (quantity > 1)
      setState(() {
        quantity--;
        subTotal = quantity * initialPrice!;
      });
  }

  //get date
  Future<DateTime?> _selectDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100));

  //get time
  Future<TimeOfDay?> _selectedTime(BuildContext context) {
    final timeNow = DateTime.now();
    return showTimePicker(
        context: context,
        cancelText: "",
        initialTime: TimeOfDay(hour: timeNow.hour, minute: timeNow.minute));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Container(
          color: Color(0xFF757575),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(twentyDp),
                    topRight: Radius.circular(twentyDp))),
            child: Padding(
              padding: const EdgeInsets.all(sixteenDp),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
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
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              imageUrl: "${widget.pastry.image}",
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
                              SizedBox(
                                width: twoHundredDp,
                                child: Text("${widget.pastry.name}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black45,
                                    )),
                              ),
                              SizedBox(
                                height: eightDp,
                              ),
                              Container(
                                  width:
                                  MediaQuery.of(context).size.width - 180,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(category,
                                          style: TextStyle(
                                            color: Colors.black45,
                                          )),
                                      Text(
                                        "${widget.pastry.category}",
                                        style: TextStyle(
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: eightDp,
                              ),
                              Container(
                                  width:
                                  MediaQuery.of(context).size.width - 180,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(price,
                                          style: TextStyle(
                                            color: Colors.black45,
                                          )),
                                      Text("$kGhanaCedi ${widget.pastry.price}",
                                          style: TextStyle(
                                              color: Colors.pink,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                              SizedBox(
                                height: eightDp,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(setQuantity,
                                      style: TextStyle(
                                        color: Colors.black45,
                                      )),
                                  SizedBox(
                                    width: fiftyDp,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _decrement(),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: sixteenDp, top: eightDp),
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.pinkAccent
                                                .withOpacity(0.4),
                                            child: Icon(
                                              Icons.remove,
                                              size: sixteenDp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: sixDp),
                                        child: Text('$quantity'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: sixteenDp, top: eightDp),
                                        child: GestureDetector(
                                          onTap: () => _increment(),
                                          child: CircleAvatar(
                                            radius: twelveDp,
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            child: Icon(
                                              Icons.add,
                                              size: sixteenDp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: twentyDp,
                    ),
                    buildDateTime(),
                    SizedBox(
                      height: twentyDp,
                    ),
                    buildTotal()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildTotal() {
    return Container(
      height: 170,
      decoration: BoxDecoration(
          color: Colors.pinkAccent.withOpacity(.1),
          borderRadius: BorderRadius.circular(eightDp)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          items(SubTotal, "$kGhanaCedi  $subTotal"),
          items(deliveryFee, willBeAdded),
          SizedBox(
            height: 8,
          ),
          Divider(
            endIndent: tenDp,
            indent: tenDp,
            color: Colors.pink,
            thickness: 1,
          ),
          items(toTAL, "$kGhanaCedi  $subTotal"),
          SizedBox(
            height: sixteenDp,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(right: sixteenDp, left: sixteenDp),
            child: SizedBox(
              height: fortyDp,
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(eightDp))),
                  onPressed: () {
                    //placing order
                    //validate inputs
                    if (_formKey.currentState!.validate()) {
                      //1.show progress
                      Dialogs.showLoadingDialog(
                          context, loadingKey, placingOrder, Colors.white);
                      //2.update provider
                      _ordersProvider.setData(
                          quantity,
                          subTotal as int,
                          widget.pastry.name!,
                          widget.pastry.image!,
                          _dateTimeController.text);
                      //3. create order
                      _ordersProvider.createOrder(context);
                    }
                  },
                  child: Text(
                    placeOrder,
                    style: TextStyle(fontSize: fourteenDp, color: Colors.white),
                  )),
            ),
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

  buildDateTime() {
    return TextFormField(
      //date time
        maxLines: 1,
        controller: _dateTimeController,
        readOnly: true,
        onTap: () async {
          final selectedDate = await _selectDate(context);
          if (selectedDate == null) return;

          final selectedTime = await _selectedTime(context);
          if (selectedTime == null) return;

          setState(() {
            _dateTime = DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day, selectedTime.hour, selectedTime.minute);

            _dateTimeController.text = _dateFormat.format(_dateTime);
          });
        },
        validator: (value) {
          return value!.length > 0 ? null : plsScheduleDate;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: sixteenDp),
            suffix: Container(
              child: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              width: thirtySixDp,
              height: thirtySixDp,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(eightDp),
                border: Border.all(width: 0.5, color: Colors.white54),
              ),
            ),
            hintText: whichDayYouNeed,
            helperText: whichDayYouNeedDes,
            helperMaxLines: 2,
            fillColor: Colors.white70,
            filled: true,
            contentPadding:
            EdgeInsets.symmetric(vertical: tenDp, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5)),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5)))));
  }
}
