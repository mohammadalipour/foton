import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:foton/common/entities/base.dart';
import 'package:foton/common/routes/routes.dart';
import 'package:foton/pages/message/state.dart';
import 'package:get/get.dart';

import '../../common/apis/chat.dart';
import '../../common/store/user.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  Future<void> goProfile() async {
    await Get.toNamed(AppRoutes.Profile,arguments: state.head_detail.value);
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

  @override
  void onInit(){
    super.onInit();
    getProfile();
  }


  void getProfile() async{
    var profile = await UserStore.to.profile;
    state.head_detail.value = profile;
    state.head_detail.refresh();
  }
}
