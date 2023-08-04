import 'package:get/get.dart';

import 'controller.dart';

class ProfileBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}