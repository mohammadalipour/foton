import 'package:get/get.dart';

import 'controller.dart';

class MessageBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController());

  }
}