import 'package:flutter/cupertino.dart';
import 'package:gelic_bakes/service/promo_service.dart';

class PromoProvider with ChangeNotifier {
  PromoService _promoService = PromoService();

  updatePromo(String promoId, context) {
    _promoService.updatePromo(context, promoId);
  }
}
