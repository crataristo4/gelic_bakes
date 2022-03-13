import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? name;
  String? category;
  String? description;
  String? image;
  int? price;

  Product({this.name, this.category, this.description, this.image, this.price});

  Product.name({this.name});

  Map<String, dynamic> nameToMap() {
    return {
      'name': name,
    };
  }

  Product.category({this.category});

  Map<String, dynamic> categoryToMap() {
    return {
      'category': category,
    };
  }

  Product.description({this.description});

  Map<String, dynamic> descriptionToMap() {
    return {
      'description': description,
    };
  }

  Product.image({this.image});

  Map<String, dynamic> imageToMap() {
    return {
      'image': image,
    };
  }

  Product.price({this.price});

  Map<String, dynamic> priceToMap() {
    return {
      'price': price,
    };
  }

  Product.nameAndPrice({this.name, this.price});

  Map<String, dynamic> nameAndPriceToMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  Product.nameAndDescription({this.name, this.description});

  Map<String, dynamic> nameAndDescriptionToMap() {
    return {
      'name': name,
      'description': description,
    };
  }

  Product.namePriceAndDescription({this.name, this.price, this.description});

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

  factory Product.fromSnapshot(DocumentSnapshot ds) {
    return Product(
      name: ds['name'],
      category: ds['category'],
      description: ds['description'],
      image: ds['image'],
      price: ds['price'],
    );
  }

  factory Product.PopularProduct(DocumentSnapshot ds) {
    return Product(
      name: ds['name'],
      category: ds['category'],
      //  description: ds['description'],
      image: ds['image'],
      price: ds['price'],
    );
  }
}
