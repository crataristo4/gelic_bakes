import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/models/orders.dart';
import 'package:gelic_bakes/service/location_service.dart';
import 'package:gelic_bakes/service/order_service.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/pages/acount_page.dart';

class OrdersProvider with ChangeNotifier {
  OrderService orderService = OrderService();
  final DateTime timeStamp = DateTime.now();

  int? _quantity;
  int? _totalPrice;
  String? _itemName;
  String? _itemImage;
  String? _orderDate;
  int? _deliveryFee;

  get getQty => _quantity;

  get getTotalPrice => _totalPrice;

  get getDeliveryAmount => _deliveryFee;

  get getItemName => _itemName;

  get getItemImage => _itemImage;

  get getOrderDate => _orderDate;

  setData(int quantity, int totalPrice, String itemName, String itemImage,
      String orderDate) {
    _quantity = quantity;
    _totalPrice = totalPrice;
    _itemName = itemName;
    _itemImage = itemImage;
    _orderDate = orderDate;

    notifyListeners();
  }

  setDelivery(int deliveryFee) {
    _deliveryFee = deliveryFee;
    notifyListeners();
  }

  createOrder(BuildContext context) {
    Orders newOrder = Orders(
        uid: currentUserId,
        name: AccountPage.userName,
        phoneNumber: phoneNumber,
        image: AccountPage.userImage,
        location: GeoPoint(GetLocationService.lat!, GetLocationService.lng!),
        quantity: getQty,
        totalPrice: getTotalPrice,
        deliveryFee: 0,
        itemName: getItemName,
        itemImage: getItemImage,
        orderDate: getOrderDate,
        timestamp: timeStamp,
        isPaid: false);

    orderService.createNewOrder(newOrder, context);
  }

  updateDeliveryFee(String id, context) {
    Orders updateDeliveryFee =
        Orders.updateDeliveryFee(deliveryFee: getDeliveryAmount);
    orderService.updateDeliveryFee(updateDeliveryFee, id, context);
  }

  updatePaidOrder(String id, context) {
    Orders updatePaidOrders = Orders.updatePaymentStatus(isPaid: true);
    orderService.updatePaidOrders(updatePaidOrders, id, context);
  }

  deleteOrder(String orderId, context) {
    orderService.deleteOrder(orderId, context);
  }
}
