import 'package:foton/common/entities/entities.dart';
import 'package:get/get.dart';

class MessageState {
  var headDetail = UserItem().obs;
  RxList<CallMessage> callList = <CallMessage>[].obs;
  RxBool tabStatus = true.obs;
  RxList<Message> msgList = <Message>[].obs;
}