import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/main.dart';
import 'package:gelic_bakes/provider/user_provider.dart';
import 'package:gelic_bakes/service/admob_service.dart';
import 'package:gelic_bakes/service/location_service.dart';
import 'package:gelic_bakes/ui/auth/config.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';
import 'package:gelic_bakes/ui/widgets/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AccountPage extends StatefulWidget with NavigationState {
  static const routeName = '/accountPage';
  static String? userName;
  static String? userImage;
  //static String? userPhone;

  final bool? hasProfile;

  const AccountPage({Key? key, required this.hasProfile}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? name;
  String? imageUrl;
  File? _image;
  final picker = ImagePicker();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  AdmobService _admobService = AdmobService();

  Position? position;
  StreamSubscription<Position>? positionStream;
  CollectionReference usersDbRef =
      FirebaseFirestore.instance.collection("Users");
  UserProvider userProvider = UserProvider();
  FocusScopeNode? currentFocus;

  @override
  void dispose() {
    positionStream!.cancel();
    positionStream = null;
    super.dispose();
  }

  @override
  void initState() {
    _admobService.createInterstitialAd();

    setState(() {
      widget.hasProfile == true
          ? _nameController.text = AccountPage.userName!
          : '';
    });

    super.initState();

    positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high,
            distanceFilter: 10,
            intervalDuration: Duration(seconds: 10))
        .listen((Position position) {
      setState(() {
        this.position = position;
      });
    });
  }

  _AccountPageState() {
    Timer(Duration(seconds: 45), () {
      _admobService.showInterstitialAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    currentFocus = FocusScope.of(context);

    popBack(context) {
      Navigator.of(context).pop();
    }

    //get image from camera
    Future getImageFromCamera(BuildContext context) async {
      final filePicked =
      await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

      if (filePicked != null) {
        setState(() {
          _image = File(filePicked.path);
        });
      }
      if (widget.hasProfile! && _image != null) {
        updateUserImage();
      }
    }

    //get image from gallery
    Future getImageFromGallery(BuildContext context) async {
      final filePicked = await picker.pickImage(source: ImageSource.gallery);

      if (filePicked != null) {
        setState(() {
          _image = File(filePicked.path);
        });
      }

      if (widget.hasProfile! && _image != null) {
        updateUserImage();
      }
    }

    //create new user
    createUser() async {
      Dialogs.showLoadingDialog(context, loadingKey, completingProfile,
          Colors.white70); //start the dialog

      String fileName = path.basename(_image!.path);
      String fileExtension = fileName.split(".").last;

      //check internet
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        DocumentSnapshot docSnapShot =
        await usersDbRef.doc(currentUserId).get();
        if (!docSnapShot.exists) {
          //create a storage reference
          firebase_storage.Reference firebaseStorageRef = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('photos/$currentUserId.$fileExtension');

          //put image file to storage
          await firebaseStorageRef.putFile(_image!);
          //get the image url
          await firebaseStorageRef.getDownloadURL().then((value) async {
            imageUrl = value;

            //update provider
            userProvider.setImage(imageUrl);
          }).whenComplete(() {
            //get location coordinates
            if (position == null) {
              userProvider.setLocation(
                  GetLocationService.lat, GetLocationService.lng);
            } else {
              userProvider.setLocation(position!.latitude, position!.longitude);
            }

            //CHECK IF IMAGE URL IS READY
            if (imageUrl != null) {
              //  userProvider.setImage(imageUrl);
              if (widget.hasProfile!) {
                userProvider.updatePhoto(context);
              } else {
                //create user
                userProvider.createUser(context);
              }
            }
          }).catchError((onError) {
            ShowAction().showToast("Error occurred : $onError", Colors.black);
          });
        } //do nothing
      } else {
        // no internet
        await new Future.delayed(const Duration(seconds: 2));
        Navigator.of(context, rootNavigator: true).pop(); //close the dialog
        ShowAction().showToast(unableToConnect, Colors.black);
      }
    }

    //choose camera or from gallery
    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: Icon(
                          Icons.photo_library,
                          color: Colors.indigo,
                        ),
                        title: Text(
                          photoLibrary,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          getImageFromGallery(context);

                          popBack(context);
                        }),
                    new ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: Colors.red,
                      ),
                      title: Text(
                        camera,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        getImageFromCamera(context);

                        popBack(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    Widget buildName() {
      return TextFormField(
        //  autofocus: true,
          controller: _nameController,
          maxLength: 20,
          keyboardType: TextInputType.name,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          onChanged: (value) async {
            name = value;
            //first update provider
            userProvider.setName(value);
          },
          validator: (value) {
            return value!.trim().length < 6 ? fullNameRequired : null;
          },
          decoration: InputDecoration(
            hintText: enterYourName,
            helperText: widget.hasProfile == true ? "" : realNameDesc,
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          ));
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () => Navigator.restorablePopAndPushNamed(
                context, ConfigurationPage.routeName),
            child: widget.hasProfile == true
                ? Container()
                : Container(
              margin: EdgeInsets.all(tenDp),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.3, color: Colors.grey),
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(thirtyDp)),
              child: Padding(
                padding: EdgeInsets.all(eightDp),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: sixteenDp,
                ),
              ),
            ),
          ),
          title: Text(
            accountSetUp,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(sixteenDp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Contains Users image
                          widget.hasProfile == true
                              ? Center(
                            child: Container(
                              height: oneFiftyDp,
                              width: oneFiftyDp,
                              child: _image == null
                                  ? ClipRRect(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                  '${AccountPage.userImage}',
                                ),
                                borderRadius: BorderRadius.circular(
                                    hundredDp),
                                clipBehavior: Clip.antiAlias,
                              )
                                  : ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(
                                    hundredDp),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 0.3,
                                    color: Colors.grey.withOpacity(0.2)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: const Offset(2.0, 4.0),
                                      blurRadius: eightDp),
                                ],
                                //color: Colors.black,
                              ),
                            ),
                          )
                              : Center(
                            child: Container(
                              height: oneFiftyDp,
                              width: oneFiftyDp,
                              child: _image == null
                                  ? ClipRRect(
                                child: Image.asset(
                                  "assets/images/avatar.png",
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(
                                    hundredDp),
                                clipBehavior: Clip.antiAlias,
                              )
                                  : ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(
                                    hundredDp),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 0.3,
                                    color: Colors.grey.withOpacity(0.2)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: const Offset(2.0, 4.0),
                                      blurRadius: eightDp),
                                ],
                                //color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: tenDp,
                          ),

                          //button to change users image
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showPicker(context);
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(eightDp)),
                                  ),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Theme.of(context).primaryColor)),
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              label: Text(
                                chooseImage,
                                style: TextStyle(
                                    fontSize: fourteenDp, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: tenDp,
                          ),
                          buildName(),
                          SizedBox(
                            height: tenDp,
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(bottom: sixDp),
                          //   height: 100,
                          //   child: AdWidget(
                          //     ad: AdmobService.createBannerFull()..load(),
                          //     key: UniqueKey(),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: sixtyDp,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: sixDp),
                        margin: EdgeInsets.symmetric(
                          horizontal: eightDp,
                        ),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () async {
                              if (widget.hasProfile == false &&
                                  formKey.currentState!.validate() &&
                                  _image != null) {
                                createUser();
                                if (!currentFocus!.hasPrimaryFocus) {
                                  currentFocus!.unfocus();
                                }
                              } else if (!widget.hasProfile! &&
                                  _image == null) {
                                ShowAction()
                                    .showToast(mustSelectPicture, Colors.red);
                              }

                              if (widget.hasProfile! &&
                                  formKey.currentState!.validate()) {
                                userProvider.updateUserName(context);

                                if (!currentFocus!.hasPrimaryFocus) {
                                  currentFocus!.unfocus();
                                }
                              }
                            },
                            child: Text(
                              widget.hasProfile == true
                                  ? updateProfile
                                  : finish,
                              style: TextStyle(fontSize: fourteenDp),
                            )),
                      ),
                    ),

                    // SizedBox(height: 1,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //update existing user photo
  void updateUserImage() async {
    Dialogs.showLoadingDialog(
        context, loadingKey, updatingProfilePicture, Colors.white70);
    String fileName = path.basename(_image!.path);
    String fileExtension = fileName.split(".").last;
    //check internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //create a storage reference
      firebase_storage.Reference firebaseStorageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('photos/$currentUserId.$fileExtension');

      //put image file to storage
      await firebaseStorageRef.putFile(_image!);
      //get the image url
      await firebaseStorageRef.getDownloadURL().then((value) async {
        imageUrl = value;
      }).whenComplete(() {
        //CHECK IF IMAGE URL IS READY
        if (imageUrl != null) {
          userProvider.setImage(imageUrl);
          userProvider.updatePhoto(context);
        }
      }).catchError((onError) {
        ShowAction().showToast("Error occurred : $onError", Colors.black);
      });
    } else {
      // no internet
      await new Future.delayed(const Duration(seconds: 2));
      Navigator.of(context, rootNavigator: true).pop(); //close the dialog
      ShowAction().showToast(unableToConnect, Colors.black);
    }
  }
}
