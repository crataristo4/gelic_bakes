import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  int? price;
  int? discountPrice;
  String? name, image, category;
  String? description;
  dynamic startDate, endDate;

  Promotion(
      {this.price,
      this.discountPrice,
      this.name,
      this.category,
      this.image,
      this.description,
      this.startDate,
      this.endDate});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'image': image,
      'description': description,
      'discountPrice': discountPrice,
      'price': price,
      'startDate': startDate,
      'endDate': endDate
    };
  }

  factory Promotion.fromSnapshot(DocumentSnapshot ds) {
    return Promotion(
      name: ds['name'],
      category: ds['category'],
      discountPrice: ds['discountPrice'],
      description: ds['description'],
      image: ds['image'],
      price: ds['price'],
      startDate: ds['startDate'],
      endDate: ds['endDate'],
    );
  }
}
