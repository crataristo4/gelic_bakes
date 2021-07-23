import 'package:cloud_firestore/cloud_firestore.dart';

class Pastry {
  String? name;
  String? category;
  String? description;
  String? image;
  int? price;

  Pastry({this.name, this.category, this.description, this.image, this.price});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'category': category,
      'price': price
    };
  }

  factory Pastry.fromSnapshot(DocumentSnapshot ds) {
    return Pastry(
      name: ds['name'],
      category: ds['category'],
      description: ds['description'],
      image: ds['image'],
      price: ds['price'],
    );
  }

  factory Pastry.freshFromOven(DocumentSnapshot ds) {
    return Pastry(
      name: ds['name'],
      category: ds['category'],
      //  description: ds['description'],
      image: ds['image'],
      price: ds['price'],
    );
  }
}
