import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foton/common/apis/apis.dart';
import 'package:foton/common/entities/chat.dart';
import 'package:foton/common/store/store.dart';
import 'package:foton/pages/message/video_call/state.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  VideoCallController();

  final state = VideoCallState();
  final player = AudioPlayer();
  String appId = dotenv.env['APP_ID']!;
  final db = FirebaseFirestore.instance;
  final profileToken = UserStore.to.profile.token;
  late final RtcEngine engine;
  ChannelMediaOptions options = const ChannelMediaOptions(
    clientRoleType: ClientRoleType.clientRoleBroadcaster,
    channelProfile: ChannelProfileType.channelProfileCommunication,
  );

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    state.toName.value = data['to_name'] ?? "";
    state.toAvatar.value = data['to_avatar'] ?? "";
    state.callRole.value = data['call_role'] ?? "";
    state.docId.value = data['doc_id'] ?? "";
    state.toToken.value = data['to_token'] ?? "";
    print("... your name id ${state.toName.value}");
    initEngine();
  }

  Future<void> initEngine() async {
    await player.setAsset("assets/Sound_Horizon.mp3");
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {},
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          state.isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elasped) async {
          state.onRemoteUID.value = remoteUid;
          state.isShowAvatar.value = false;
          await player.pause();
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          state.isJoined.value = false;
          state.onRemoteUID.value = 0;
          state.isShowAvatar.value = true;
        },
        onRtcStats: (RtcConnection connection, RtcStats state) {
        }));

    await engine.enableVideo();
    await engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640,height: 360),
        frameRate: 15,
        bitrate: 0
      )
    );
    await engine.startPreview();
    state.isReadyPreview.value = true;
    await joinChannel();
    await sendNotification("video");
    if (state.callRole == "anchor") {
      await player.play();
    }
  }

  Future<String> sendNotification(String callType) async {
    CallRequestEntity callTokenRequestEntity = CallRequestEntity();
    callTokenRequestEntity.call_type = callType;
    callTokenRequestEntity.to_token = state.toToken.value;
    callTokenRequestEntity.to_avatar = state.toAvatar.value;
    callTokenRequestEntity.doc_id = state.docId.value;
    callTokenRequestEntity.to_name = state.toName.value;
    print(".... the other user token is : ${state.toToken.value}");

    var res = await ChatAPI.call_notifications(params: callTokenRequestEntity);
    if (res.code == 0) {
      print("notification sent");
    } else {
      print("Notification has problem");
    }

    return res.msg!;
  }

  Future<String> getToken() async {
    if (state.callRole == "anchor") {
      state.channelId.value = md5
          .convert(utf8.encode("${profileToken}_${state.toToken}"))
          .toString();
    } else {
      state.channelId.value = md5
          .convert(utf8.encode("${state.toToken}_${profileToken}"))
          .toString();
    }

    CallTokenRequestEntity callTokenRequestEntity = CallTokenRequestEntity();
    callTokenRequestEntity.channel_name = state.channelId.value;
    print("... channel id is ${state.channelId.value}");
    print("...my access token is ${UserStore.to.token}");
    var res = await ChatAPI.call_token(params: callTokenRequestEntity);
    if (res.code == 0) {
      return res.data!;
    }
    return "";
  }

  Future<void> joinChannel() async {
    await [Permission.microphone,Permission.camera].request();
    EasyLoading.show(
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    String token = await getToken();
    if (token.isEmpty) {
      EasyLoading.dismiss();
      Get.back();
      return;
    }

    await engine.joinChannel(
        token: token,
        channelId: state.channelId.value,
        uid: 0,
        options: options);
    EasyLoading.dismiss();
  }

  Future<void> leaveChannel() async {
    EasyLoading.show(
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    await player.pause();
    await sendNotification("cancel");
    state.isJoined.value = false;
    state.switchCamera.value = true;
    EasyLoading.dismiss();
    Get.back();
  }

  Future<void> switchCamera() async{
    await engine.switchCamera();
    state.switchCamera.value = !state.switchCamera.value;
  }

  Future<void> _dispose() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
