import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/main.dart';
import 'package:gelic_bakes/provider/pastry_provider.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';
import 'package:gelic_bakes/ui/widgets/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddItem extends StatefulWidget {
  static const routeName = '/addItem';

  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String? imageUrl;
  File? _image;
  String? price;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String? _selectedItem;
  PastryProvider _pastryProvider = PastryProvider();

  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _itemNameController = TextEditingController();

  @override
  void dispose() {
    _priceController.clear();
    _descriptionController.clear();
    _itemNameController.clear();
    super.dispose();
  } //get image from camera

  Future getImageFromCamera(BuildContext context) async {
    final filePicked =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (filePicked != null) {
      setState(() {
        _image = File(filePicked.path);
      });
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
  }

  //upload image
  void uploadImage() async {
    Dialogs.showLoadingDialog(context, loadingKey, uploading, Colors.white70);
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
          .child('pastry/$fileName.$fileExtension');

      //put image file to storage
      await firebaseStorageRef.putFile(_image!);
      //get the image url
      await firebaseStorageRef.getDownloadURL().then((value) async {
        setState(() {
          imageUrl = value;
        });
      }).whenComplete(() {
        //CHECK IF IMAGE URL IS READY
        if (imageUrl != null) {
          _pastryProvider.setData(
              _itemNameController.text,
              _selectedItem!,
              _descriptionController.text,
              imageUrl!,
              int.parse(_priceController.text));
          _pastryProvider.insertIntoDb(context);
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

  //choose camera or from gallery
  void _showPicker(context) async {
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
                      title: Text(photoLibrary,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        getImageFromGallery(context);

                        Navigator.of(context).pop();
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

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildItemName() {
    return TextFormField(
        maxLength: 100,
        keyboardType: TextInputType.number,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: _itemNameController,
        validator: (value) {
          return value!.trim().length < 1 ? 'Enter item name' : null;
        },
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: 'Enter item name',
          fillColor: Color(0xFFF5F5F5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
        ));
  }

  Widget buildPrice() {
    return TextFormField(
        maxLength: 10,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: _priceController,
        validator: (value) {
          return value!.trim().length < 1 ? 'Enter an amount' : null;
        },
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: 'Enter the price',
          fillColor: Color(0xFFF5F5F5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
        ));
  }

  Widget buildDescription() {
    return TextFormField(
        maxLength: 200,
        keyboardType: TextInputType.number,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: _descriptionController,
        /*validator: (value) {
          return value!.trim().length < 1 ? 'Enter an description' : null;
        },*/
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: 'Enter the description',
          fillColor: Color(0xFFF5F5F5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
        ));
  }

  Widget buildPastryType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(sixDp),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(eightDp),
              border:
                  Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
          child: DropdownButtonFormField<String>(
            value: _selectedItem,
            elevation: 1,
            isExpanded: true,
            style: TextStyle(color: Color(0xFF424242)),
            // underline: Container(),
            items: [cake, chips, cookies, doughnut, pie]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text(
              selectAType,
              style: TextStyle(color: Color(0xFF757575), fontSize: 16),
            ),
            onChanged: (String? value) {
              setState(() {
                _selectedItem = value;
              });
            },
            validator: (value) => value == null ? categoryRequired : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(addItem),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Container(
            color: Color(0xFF757575),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(twentyDp),
                      topRight: Radius.circular(twentyDp))),
              child: Padding(
                padding: const EdgeInsets.all(twentyFourDp),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _image == null
                          ? Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text('tap to add image',
                                          style: TextStyle(
                                              color: Colors.black54))),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => _showPicker(context),
                              child: Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 10),
                      buildItemName(),
                      SizedBox(height: 10),
                      buildPastryType(),
                      SizedBox(height: 10),
                      buildPrice(),
                      SizedBox(height: 10),
                      buildDescription(),
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(right: sixteenDp, top: eightDp),
                        child: SizedBox(
                          height: fortyDp,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(eightDp))),
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    _image != null) {
                                  // trigger function
                                  uploadImage();
                                } else if (_image == null) {
                                  ShowAction()
                                      .showToast(mustSelectImage, Colors.red);
                                }
                              },
                              child: Text(
                                done,
                                style: TextStyle(
                                    fontSize: fourteenDp, color: Colors.white),
                              )),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
