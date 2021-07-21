import 'package:rxdart/rxdart.dart';

import 'validator/login_validator.dart';

class LoginBloc extends Object with LoginValidator implements BaseBloc {
  final _phoneNumberController = BehaviorSubject<String>();

  Stream<String> get phoneNumberStream =>
      _phoneNumberController.stream.transform(validateNumber);

  Function(String) get onPhoneNumberChanged => _phoneNumberController.sink.add;

  ///@ method combinelastest1 was manually added to the  rx.dart api to support a single stream
  ///only use it for a single stream
  Stream<bool> get submitPhoneNumber =>
      Rx.combineLatest1(phoneNumberStream, (values) => true);

  @override
  void dispose() {
    _phoneNumberController.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
