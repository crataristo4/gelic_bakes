import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String? uid;
  String? name;
  String? phoneNumber;
  String? image;
  GeoPoint? location;
  int? quantity;
  int? totalPrice;
  int? deliveryFee;
  String? itemName;
  String? itemImage;
  String? orderDate;
  dynamic timestamp;
  bool? isPaid;

  Orders(
      {this.uid,
      this.name,
      this.phoneNumber,
      this.image,
      this.location,
      this.quantity,
      this.totalPrice,
      required this.deliveryFee,
      this.itemName,
      this.itemImage,
      this.orderDate,
      this.timestamp,
      this.isPaid});

  Orders.updateDeliveryFee({this.deliveryFee});

  Map<String, dynamic> deliveryFeeToMap() {
    return {
      'deliveryFee': deliveryFee,
    };
  }

  Orders.updatePaymentStatus({this.isPaid});

  Map<String, dynamic> isPaidToMap() {
    return {
      'isPaid': isPaid,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'image': image,
      'phoneNumber': phoneNumber,
      'location': location,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'deliveryFee': deliveryFee,
      'itemName': itemName,
      'itemImage': itemImage,
      'orderDate': orderDate,
      'timestamp': timestamp,
      'isPaid': isPaid,
    };
  }

  factory Orders.fromSnapshot(DocumentSnapshot ds) {
    return Orders(
        uid: ds['uid'],
        name: ds['name'],
        phoneNumber: ds['phoneNumber'],
        image: ds['image'],
        location: ds['location'],
        quantity: ds['quantity'],
        totalPrice: ds['totalPrice'],
        itemName: ds['itemName'],
        itemImage: ds['itemImage'],
        orderDate: ds['orderDate'],
        timestamp: ds['timestamp'],
        deliveryFee: ds['deliveryFee'],
        isPaid: ds['isPaid']);
  }

  int getTotalPayment() {
    return (deliveryFee! + totalPrice!);
  }
}
