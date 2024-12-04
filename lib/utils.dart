import 'package:cypto_currency_app/controller/assets_controller.dart';
import 'package:cypto_currency_app/services/http_service.dart';
import 'package:get/get.dart';

Future<void> registerService() async {
  Get.put(
    HttpService(),
  );
}

Future<void> registerControllers() async {
  Get.put(
    AssetsController(),
  );
}

String getCryptoImageUrl (String name){
  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}