import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  final id;
  int? price;
  int? discountPrice;
  String? name, image, category;
  String? description;
  String? endDate;
  bool? isEnded;

  Promotion(
      {this.id,
      this.price,
      this.discountPrice,
      this.name,
      this.category,
      this.image,
      this.description,
      this.endDate,
      this.isEnded});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
      'description': description,
      'discountPrice': discountPrice,
      'price': price,
      'endDate': endDate,
      'isEnded': isEnded
    };
  }

  factory Promotion.fromSnapshot(DocumentSnapshot ds) {
    return Promotion(
        id: ds['id'],
        name: ds['name'],
        category: ds['category'],
        discountPrice: ds['discountPrice'],
        description: ds['description'],
        image: ds['image'],
        price: ds['price'],
        endDate: ds['endDate'],
        isEnded: ds['isEnded']);
  }

  factory Promotion.fromFirestore(Map<String, dynamic> ds) {
    return Promotion(
        id: ds['id'],
        name: ds['name'],
        category: ds['category'],
        discountPrice: ds['discountPrice'],
        description: ds['description'],
        image: ds['image'],
        price: ds['price'],
        endDate: ds['endDate'],
        isEnded: ds['isEnded']);
  }
}
