import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id, name, image, phoneNumber;
  GeoPoint? location;

  Users(
      {required this.id,
      required this.name,
      required this.image,
      required this.phoneNumber,
      this.location});

  Users.name({this.name});

  Users.image({this.image});

  Users.location({this.location});

  factory Users.fromMap(DocumentSnapshot ds) {
    return Users(
        id: ds['id'],
        name: ds['name'],
        image: ds['image'],
        phoneNumber: ds['phoneNumber'],
        location: ds['location']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'image': image,
      'location': location
    };
  }

  Map<String, dynamic> nameToMap() {
    return {
      'name': name,
    };
  }

  Map<String, dynamic> imageToMap() {
    return {
      'image': image,
    };
  }

  Map<String, dynamic> locationToMap() {
    return {
      'location': location,
    };
  }
}
