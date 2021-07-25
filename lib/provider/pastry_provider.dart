import 'package:flutter/material.dart';
import 'package:gelic_bakes/models/pastry.dart';
import 'package:gelic_bakes/service/pastry_service.dart';

class PastryProvider with ChangeNotifier {
  String? _description, _name, _image, _category;
  int? _price;
  PastryService pastryService = PastryService();

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
    Pastry newPastry = Pastry(
        name: getName,
        category: getCategory,
        description: getDescription == null ? "" : getDescription,
        image: getImage,
        price: getPrice);

    pastryService.createNewPastry(newPastry, context);
  }

  //update pastry name
  updatePastryName(BuildContext context, String itemId) {
    Pastry updateName = Pastry.name(
      name: getName,
    );

    pastryService.updatePastryName(updateName, context, itemId);
  }

  //update pastry category
  updatePastryCategory(BuildContext context, String itemId) {
    Pastry updateCategory = Pastry.category(
      category: getCategory,
    );

    pastryService.updatePastryCategory(updateCategory, context, itemId);
  }

  //update pastry price
  updatePastryPrice(BuildContext context, String itemId) {
    Pastry updatePrice = Pastry.price(
      price: getPrice,
    );

    pastryService.updatePastryPrice(updatePrice, context, itemId);
  }

  //update pastry image
  updatePastryImage(BuildContext context, String itemId) {
    Pastry updateImage = Pastry.price(
      price: getPrice,
    );

    pastryService.updatePastryImage(updateImage, context, itemId);
  }

  //update pastry description
  updatePastryDescription(BuildContext context, String itemId) {
    Pastry updateDescription = Pastry.description(
      description: getDescription,
    );

    pastryService.updatePastryDes(updateDescription, context, itemId);
  }

  //update pastry name and price
  updatePastryNameAndPrice(BuildContext context, String itemId) {
    Pastry updateName = Pastry.nameAndPrice(name: getName, price: getPrice);

    pastryService.updateNameAndPrice(updateName, context, itemId);
  }

  //update pastry name and price
  updatePastryNameAndDescription(BuildContext context, String itemId) {
    Pastry updateName =
        Pastry.nameAndDescription(name: getName, description: getDescription);

    pastryService.updateNameAndDescription(updateName, context, itemId);
  }

  //update pastry name and price
  updatePastryNamePriceAndDescription(BuildContext context, String itemId) {
    Pastry updateNamePriceDescription = Pastry.namePriceAndDescription(
        name: getName, price: getPrice, description: getDescription);

    pastryService.updateNamePriceAndDescription(
        updateNamePriceDescription, context, itemId);
  }
}
