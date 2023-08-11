import 'package:foton/pages/message/chat/state.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  ChatController();

  final state = ChatState();
  late String docId;

  void goMore(){
    state.moreStatus.value = state.moreStatus.value? false : true;
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
