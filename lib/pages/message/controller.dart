import 'package:foton/common/routes/routes.dart';
import 'package:foton/pages/message/state.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  Future<void> goProfile() async {
    await Get.toNamed(AppRoutes.Profile);
  }
}
