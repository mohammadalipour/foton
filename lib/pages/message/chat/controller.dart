import 'package:foton/pages/message/chat/state.dart';
import 'package:get/get.dart';

import '../../../common/routes/names.dart';

class ChatController extends GetxController {
  ChatController();

  final state = ChatState();
  late String docId;

  void goMore(){
    state.moreStatus.value = state.moreStatus.value? false : true;
  }

  void audioCall(){
    state.moreStatus.value = false;
    Get.toNamed(AppRoutes.VoiceCall,parameters: {
      "to_token": state.toToken.value,
      "to_name":state.toName.value,
      "to_avatar":state.toAvatar.value,
      "call_role": "anchor",
      "doc_id": docId
    });
  }

  @override
  void onInit(){
    super.onInit();
    var data = Get.parameters;
    print(data);
    docId = data['doc_id']!;
    state.toToken.value = data['to_token']??"";
    state.toName.value = data['to_name']??"";
    state.toAvatar.value = data['to_avatar']??"";
    state.toOnline.value = data['to_online']??"1";
  }
}
