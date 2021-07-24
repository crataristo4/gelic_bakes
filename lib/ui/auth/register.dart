import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelic_bakes/bloc/login_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/main.dart';
import 'package:gelic_bakes/provider/auth_provider.dart';
import 'package:gelic_bakes/ui/auth/verify.dart';
import 'package:gelic_bakes/ui/widgets/actions.dart';
import 'package:gelic_bakes/ui/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  static const routeName = '/registerPage';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final loginBloc = LoginBloc();
  TextEditingController _phoneNumberController = TextEditingController();

  //...................................................//

  String selectedCountryCode = '+233';

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(anErrorOccurred),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(OK),
          )
        ],
      ),
    );
  }

  //method to verify phone number
  verifyPhone(BuildContext context) async {
    //if connected show dialog for user to proceed
    String phoneNumber = "$selectedCountryCode${_phoneNumberController.text}";

    ShowAction.showAlertDialog(
        confirmNumber,
        "$sendCodeTo$phoneNumber",
        context,
        TextButton(
          child: Text(
            edit,
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(send, style: TextStyle(color: Colors.green)),
          onPressed: () {
            //if yes or ... then push the phone number and user type to verify number
            //NB: The user type will enable you to switch the state between USERS and ARTISAN
            Navigator.pop(context);
            try {
              Provider.of<AuthProvider>(context, listen: false)
                  .verifyPhone(phoneNumber)
                  .then((value) async {
                Dialogs.showLoadingDialog(
                    //show dialog and delay
                    context,
                    loadingKey,
                    sendingCode,
                    Colors.white70);
                await Future.delayed(const Duration(seconds: 3));
                Navigator.of(context, rootNavigator: false).pop(true);

                Navigator.of(context).pushNamed(VerificationPage.routeName,
                    arguments: phoneNumber);
              }).catchError((e) {
                String errorMsg = cantAuthenticate;
                if (e.toString().contains(containsBlockedMsg)) {
                  errorMsg = plsTryAgain;
                }
                _showErrorDialog(context, errorMsg);
              });
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
        ));
  }

  //method to select country code when changed
  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: twoHundredDp),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(thirtySixDp),
                          topRight: Radius.circular(thirtySixDp)),
                      border: Border.all(
                          width: 0.2, color: Colors.grey.withOpacity(0.5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: thirtyDp,
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            left: thirtySixDp, top: thirtySixDp, bottom: tenDp),
                        child: Text(
                          enterPhoneToLogin,
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),

                      //CONTAINER FOR TEXT FORM FIELD
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: thirtySixDp),
                        child: StreamBuilder<String>(
                            stream: loginBloc.phoneNumberStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                  maxLength: 9,
                                  autofocus: true,
                                  keyboardType: TextInputType.phone,
                                  controller: _phoneNumberController,
                                  onChanged: loginBloc.onPhoneNumberChanged,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  decoration: InputDecoration(
                                    hintText: '54 xxx xxxx',
                                    errorText: snapshot.error == null
                                        ? ""
                                        : snapshot.error as String,
                                    fillColor: Color(0xFFF5F5F5),
                                    prefix: CountryCodePicker(
                                      onChanged: _onCountryChange,
                                      showFlag: true,
                                      initialSelection: selectedCountryCode,
                                      showOnlyCountryWhenClosed: false,
                                    ),
                                    suffix: Padding(
                                      padding: EdgeInsets.only(right: eightDp),
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      ),
                                    ),
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: fourDp),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF5F5F5))),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF5F5F5))),
                                  ));
                            }),
                      ),
                      SizedBox(
                        height: sixtyDp,
                      ),

                      //button to login user
                      StreamBuilder<bool>(
                          stream: loginBloc.submitPhoneNumber,
                          builder: (context, snapshot) => SizedBox(
                                height: fortyEightDp,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: thirtySixDp),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      onPressed: snapshot
                                              .hasData //if the text form field has some data then proceed to verify number
                                          ? () => verifyPhone(context)
                                          : null, //else do nothing
                                      child: Text(
                                        verifyNumber,
                                        style: TextStyle(fontSize: 14),
                                      )),
                                ),
                              )),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
