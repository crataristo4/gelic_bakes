import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:gelic_bakes/provider/user_provider.dart';
import 'package:geolocator/geolocator.dart';

class GetLocationService {
  //for getting location coordinates
  Position? position;
  static double? lat, lng;
  StreamSubscription<Position>? positionStream;
  UserProvider _userProvider = UserProvider(); //for updating user details

  Future<Position>? getUserCoordinates(BuildContext context) {
    Timer(Duration(seconds: 30), () {
      positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.high,
              distanceFilter: 10,
              intervalDuration: Duration(seconds: 10))
          .listen((Position position) {
        //update artisans location coordinates
        if (position != null) {
          this.position = position;

          lat = position.latitude;
          lng = position.longitude;

          _userProvider.updateLocationCoordinates(
              context, position.latitude, position.longitude);

          dispose();
        }
      });
    });
  }

  getLastKnownLocation() async {
    position = await Geolocator.getLastKnownPosition();

    return position;
  }

  double getDistanceInKilometers(double usersLatitude, double usersLongitude,
      double artisansLatitude, double artisansLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
        usersLatitude, usersLongitude, artisansLatitude, artisansLongitude);

    double distanceToKm = distanceInMeters / 1000;

    return distanceToKm;
  }

  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
      positionStream = null;
    }
  }

//todo - handle location permissions
}
