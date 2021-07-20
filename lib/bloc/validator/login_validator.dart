import 'dart:async';

import 'package:gelic_bakes/constants/constants.dart';

mixin LoginValidator {
  var validateNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (phoneNumber, sink) {
    if (phoneNumber.startsWith("24") ||
        phoneNumber.startsWith("54") ||
        phoneNumber.startsWith("55") ||
        phoneNumber.startsWith("59") ||
        phoneNumber.startsWith("57") ||
        phoneNumber.startsWith("26") ||
        phoneNumber.startsWith("56") ||
        phoneNumber.startsWith("27") ||
        phoneNumber.startsWith("23") ||
        phoneNumber.startsWith("20") ||
        phoneNumber.startsWith("50")) {
      if (phoneNumber.length == 9) {
        sink.add(phoneNumber);
      } else {
        sink.addError(invalidPhone);
      }
    } else {
      sink.addError(enterValidGhanaNumber);
    }
  });
}
