import 'package:flutter/material.dart';
import 'package:gelic_bakes/models/product.dart';
import 'package:gelic_bakes/service/product_service.dart';

class ProductProvider with ChangeNotifier {
  String? _description, _name, _image, _category;
  int? _price;
  ProductService productService = ProductService();

  get getName => _name;

  get getImage => _image;

  get getCategory => _category;

  get getDescription => _description;

  get getPrice => _price;

  //updates ............................
  setItemName(String name) {
    _name = name;
    notifyListeners();
  }

  setItemPrice(int price) {
    _price = price;
    notifyListeners();
  }

  setItemCategory(String category) {
    _category = category;
    notifyListeners();
  }

  setItemImage(String image) {
    _image = image;
    notifyListeners();
  }

  setItemDescription(String description) {
    _description = description;
    notifyListeners();
  }

  //......................................

  setData(String name, String category, String description, String image,
      int price) {
    _name = name;
    _image = image;
    _category = category;
    _description = description;
    _price = price;
    notifyListeners();
  }

  insertIntoDb(BuildContext context) {
    Product newProduct = Product(
        name: getName,
        category: getCategory,
        description: getDescription == null ? "" : getDescription,
        image: getImage,
        price: getPrice);

    productService.createNewProduct(newProduct, context);
  }

  //update Product name
  updateProductName(BuildContext context, String itemId) {
    Product updateName = Product.name(
      name: getName,
    );

    productService.updateProductName(updateName, context, itemId);
  }

  //update Product category
  updateProductCategory(BuildContext context, String itemId) {
    Product updateCategory = Product.category(
      category: getCategory,
    );

    productService.updateProductCategory(updateCategory, context, itemId);
  }

  //update Product price
  updateProductPrice(BuildContext context, String itemId) {
    Product updatePrice = Product.price(
      price: getPrice,
    );

    productService.updateProductPrice(updatePrice, context, itemId);
  }

  //update Product image
  updateProductImage(BuildContext context, String itemId) {
    Product updateImage = Product.price(
      price: getPrice,
    );

    productService.updateProductImage(updateImage, context, itemId);
  }

  //update Product description
  updateProductDescription(BuildContext context, String itemId) {
    Product updateDescription = Product.description(
      description: getDescription,
    );

    productService.updateProductDes(updateDescription, context, itemId);
  }

  //update Product name and price
  updateProductNameAndPrice(BuildContext context, String itemId) {
    Product updateName = Product.nameAndPrice(name: getName, price: getPrice);

    productService.updateNameAndPrice(updateName, context, itemId);
  }

  //update Product name and price
  updateProductNameAndDescription(BuildContext context, String itemId) {
    Product updateName =
        Product.nameAndDescription(name: getName, description: getDescription);

    productService.updateNameAndDescription(updateName, context, itemId);
  }

  //update Product name and price
  updateProductNamePriceAndDescription(BuildContext context, String itemId) {
    Product updateNamePriceDescription = Product.namePriceAndDescription(
        name: getName, price: getPrice, description: getDescription);

    productService.updateNamePriceAndDescription(
        updateNamePriceDescription, context, itemId);
  }
}
