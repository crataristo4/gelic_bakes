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
}
