import 'package:cloud_firestore/cloud_firestore.dart';

class Pastry {
  String? name;
  String? category;
  String? description;
  String? image;
  int? price;

  Pastry({this.name, this.category, this.description, this.image, this.price});

  Pastry.name({this.name});

  Map<String, dynamic> nameToMap() {
    return {
      'name': name,
    };
  }

  Pastry.category({this.category});

  Map<String, dynamic> categoryToMap() {
    return {
      'category': category,
    };
  }

  Pastry.description({this.description});

  Map<String, dynamic> descriptionToMap() {
    return {
      'description': description,
    };
  }

  Pastry.image({this.image});

  Map<String, dynamic> imageToMap() {
    return {
      'image': image,
    };
  }

  Pastry.price({this.price});

  Map<String, dynamic> priceToMap() {
    return {
      'price': price,
    };
  }

  Pastry.nameAndPrice({this.name, this.price});

  Map<String, dynamic> nameAndPriceToMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  Pastry.nameAndDescription({this.name, this.description});

  Map<String, dynamic> nameAndDescriptionToMap() {
    return {
      'name': name,
      'description': description,
    };
  }

  Pastry.namePriceAndDescription({this.name, this.price, this.description});

  Map<String, dynamic> namePriceAndDescriptionToMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }

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
