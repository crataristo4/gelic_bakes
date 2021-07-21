import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/ui/auth/register.dart';
import 'package:gelic_bakes/ui/sidebar/sidebar_layout.dart';

String? currentUserId;
String? phoneNumber;

class ConfigurationPage extends StatefulWidget {
  static const routeName = '/';

  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final mAuth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    try {
      //get current userId and phone number
      setState(() {
        currentUserId = FirebaseAuth.instance.currentUser!.uid;
        phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      });
    } catch (error) {
      print("Error on App state : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Container(
        child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
                body: currentUserId != null
                    ? SidebarLayout()
                    : RegistrationPage())),
      ),
    );
  }
}
