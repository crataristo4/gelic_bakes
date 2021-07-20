import 'dart:async';

import 'package:gelic_bakes/constants/constants.dart';

mixin LoginValidator {
  var validateNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (phoneNumber, sink) {
    if (phoneNumber.startsWith("024") ||
        phoneNumber.startsWith("054") ||
        phoneNumber.startsWith("055") ||
        phoneNumber.startsWith("059") ||
        phoneNumber.startsWith("057") ||
        phoneNumber.startsWith("026") ||
        phoneNumber.startsWith("056") ||
        phoneNumber.startsWith("027") ||
        phoneNumber.startsWith("023") ||
        phoneNumber.startsWith("020") ||
        phoneNumber.startsWith("050")) {
      if (phoneNumber.length == 10) {
        sink.add(phoneNumber);
      } else {
        sink.addError(invalidPhone);
      }
    } else {
      sink.addError(enterValidGhanaNumber);
    }
  });
}
