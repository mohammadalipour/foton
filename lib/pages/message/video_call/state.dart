import 'package:get/get.dart';

class VideoCallState {
  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool enableSpeaker = true.obs;
  RxString callTime = "00:00".obs;
  RxString callTimeStatus = "not connected".obs;

  var toToken = "".obs;
  var toName = "".obs;
  var toAvatar = "".obs;
  var docId = "".obs;
  var callRole = "audience".obs;
  var channelId ="not connected".obs;

  RxBool isReadyPreview=false.obs;
  RxBool isShowAvatar = true.obs;
  RxBool switchCamera = true.obs;
  RxInt onRemoteUID = 0.obs;
}