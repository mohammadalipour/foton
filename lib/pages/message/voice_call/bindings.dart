import 'package:get/get.dart';

import 'controller.dart';

class VoiceCallBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<VoiceCallController>(() => VoiceCallController());

  }
}