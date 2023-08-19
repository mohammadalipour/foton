import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:foton/common/entities/base.dart';
import 'package:foton/common/routes/routes.dart';
import 'package:foton/pages/message/state.dart';
import 'package:get/get.dart';

import '../../common/apis/chat.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  Future<void> goProfile() async {
    await Get.toNamed(AppRoutes.Profile);
  }

  @override
  void onReady(){
    super.onReady();
    firebaseMessageSetup();
  }

  firebaseMessageSetup() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("... my device token is $fcmToken");
    if(fcmToken!=null){
      BindFcmTokenRequestEntity bindFcmTokenRequestEntity =  BindFcmTokenRequestEntity();
      bindFcmTokenRequestEntity.fcmtoken = fcmToken;
      await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
    }
  }
}
