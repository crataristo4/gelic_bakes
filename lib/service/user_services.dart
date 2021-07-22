import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/models/Users.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/pages/acount_page.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';

class UserService {
  final firestoreService = FirebaseFirestore.instance;

  //create a user
  Future<void> createUser(Users users, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(users.id)
        .set(users.toMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update name
  Future<void> updateUserName(Users user, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .update(user.nameToMap())
        .whenComplete(() {
      showUpdatingSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update PHOTO
  Future<void> updatePhotoUrl(Users user, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .update(user.imageToMap())
        .whenComplete(() async {
      showUpdatingSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update location
  Future<void> updateLocation(BuildContext context, double lat, double lng) {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .update({'location': GeoPoint(lat, lng)})
        .whenComplete(() {})
        .catchError((onError) {
          showFailure(context, onError);
        });
  }

  //check user details
  Future<void> getCurrentUser(BuildContext context) async {
    try {
      if (currentUserId != null) {
        //check the database if user has details
        await firestoreService
            .collection('Users')
            .doc(currentUserId)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            AccountPage.userName = documentSnapshot.get('name');
            AccountPage.userImage = documentSnapshot.get('image');
            AccountPage.userPhone = documentSnapshot.get('phoneNumber');
          } else {
            //if not then navigate to complete profile
            pushToCompleteProfile(context);
          }
        }).catchError((onError) {
          debugPrint("Error: $onError");
        });

//------------------------------------------------------------------------------------------------

      }
    } catch (error) {
      print("Error on HOme state : $error");
    }
  }

//----------------------------------------------------------------------------------------------------------------------
  showSuccess(context) async {
    await Future.delayed(Duration(seconds: 3));
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(ConfigurationPage.routeName, (route) => false);
  }

  showUpdatingSuccess(context) async {
    Navigator.of(context, rootNavigator: true).pop();
    ShowAction().showToast(updated, Colors.red);
    Navigator.of(context).pushNamed(ConfigurationPage.routeName);
  }

  showNameUpdatingSuccess(context) async {
    ShowAction().showToast(userNameUpdated, Colors.black); //show complete msg
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }

  //push to complete profile when user has no record
  pushToCompleteProfile(BuildContext context) async {
    await new Future.delayed(Duration(seconds: 0));
    Navigator.of(context)
        .pushReplacementNamed(AccountPage.routeName, arguments: false);
  }

//------------------------------------------------------------------------------------------------------------
}
