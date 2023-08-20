import 'package:foton/common/entities/entities.dart';
import 'package:get/get.dart';

class ChatState {
  RxList<Msgcontent> msgContentList = <Msgcontent>[].obs;
  var toToken= "".obs;
  var toName = "".obs;
  var toAvatar = "".obs;
  var toOnline = "".obs;
  RxBool moreStatus = false.obs;
  RxBool isLoading = false.obs;
}