import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/main.dart';
import 'package:gelic_bakes/models/Users.dart';
import 'package:gelic_bakes/service/user_services.dart';
import 'package:gelic_bakes/ui/pages/acount_page.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';
import 'package:gelic_bakes/ui/widgets/progress_dialog.dart';
import 'package:intl/intl.dart';

class UserProvider with ChangeNotifier {
  String? _id, _name, _image, _phoneNumber;
  double? _latitude, _longitude;
  DateFormat dateFormat = DateFormat().add_yMMMMEEEEd();

  get getName => _name;

  get getImage => _image;

  get latitude => _latitude;

  get longitude => _longitude;

  UserService userService = UserService();

  setLocation(double? lat, double? lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }

  setName(value) {
    _name = value;
    notifyListeners();
  }

  setImage(value) {
    _image = value;
    notifyListeners();
  }

  //CREATE NEW USER
  createUser(BuildContext context) async {
    _id = FirebaseAuth.instance.currentUser!.uid;
    _phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

    // create new  user object
    Users newUser = Users(
        name: getName,
        image: getImage,
        phoneNumber: _phoneNumber!,
        id: _id!,
        location: new GeoPoint(_latitude!, _longitude!));

    //create record in db
    userService.createUser(newUser, context);
  }

  //UPDATE USER name
  updateUserName(BuildContext context) async {
    if (getName == null || getName == AccountPage.userName) {
      ShowAction().showToast(nothingToUpdate, Colors.red);
    } else {
      Dialogs.showLoadingDialog(
          context, loadingKey, updatingName, Colors.white70);
      // update  user object
      Users updateUser = Users.name(name: getName);
      //create record in db
      userService.updateUserName(updateUser, context);
    }
  }

  //UPDATE PHOTO
  updatePhoto(BuildContext context) async {
    if (getImage == null) {
    } else {
      // update  user object
      Users updateUser = Users.image(image: getImage);
      //create record in db
      userService.updatePhotoUrl(updateUser, context);
    }
  }

  //update location coordinates
  updateLocationCoordinates(BuildContext context, double? lat, double? lng) {
    userService.updateLocation(context, lat!, lng!);
  }
}
