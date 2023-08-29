import 'dart:async';
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
import 'package:foton/pages/message/voice_call/state.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';


class VoiceCallController extends GetxController {
  VoiceCallController();

  final state = VoiceCallState();
  final player = AudioPlayer();
  String appId = dotenv.env['APP_ID']!;
  final db = FirebaseFirestore.instance;
  final profileToken = UserStore.to.profile.token;
  late final RtcEngine engine;
  int callSecond = 0;
  int callMinute = 0;
  int callHour = 0;
  late final Timer callTimer;
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
    state.callRole.value = data['call_role']?? "";
    state.docId.value = data['doc_id']?? "";
    state.toToken.value = data['to_token']?? "";
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
        onError: (ErrorCodeType err, String msg) {
      print('[onError] err: $err, msg:$msg');
    }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      print('.... onConnection ${connection.toJson()}');
      state.isJoined.value = true;
    }, onUserJoined:
            (RtcConnection connection, int remoteUid, int elasped) async {
      await player.pause();
      callTime();
    }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
      print("... user left the room ...");
      state.isJoined.value = false;
    }, onRtcStats: (RtcConnection connection, RtcStats state) {
      print("time ... ");
      print(state.duration);
    }));

    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioGameStreaming);
    await joinChannel();
    await sendNotification("voice");
    if(state.callRole=="anchor"){
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
    if(res.code==0){
      print("notification sent");
    }else {
      print("Notification has problem");
    }

    return res.msg!;
  }

  Future<String> getToken() async {
    if(state.callRole=="anchor"){
      state.channelId.value = md5.convert(utf8.encode("${profileToken}_${state.toToken}")).toString();
    }else{
      state.channelId.value = md5.convert(utf8.encode("${state.toToken}_${profileToken}")).toString();
    }

    CallTokenRequestEntity callTokenRequestEntity =  CallTokenRequestEntity();
    callTokenRequestEntity.channel_name = state.channelId.value;
    print("... channel id is ${state.channelId.value}");
    print("...my access token is ${UserStore.to.token}");
    var res = await ChatAPI.call_token(params: callTokenRequestEntity);
    if(res.code==0) {
      return res.data!;
    }
    return "";
  }

  Future<void> joinChannel() async {
    await Permission.microphone.request();
    EasyLoading.show(
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true
    );

    String token = await getToken();
    if(token.isEmpty){
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
    EasyLoading.dismiss();
    Get.back();
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

  void callTime() {
    callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      callSecond = callSecond + 1;
      if(callSecond >= 60){
        callSecond =0;
        callMinute = callMinute + 1;
      }
      if(callMinute >= 60){
        callMinute =0;
        callHour = callHour + 1;
      }
      var hour = callHour < 10 ? "0$callHour" : "$callHour";
      var minute = callMinute < 10 ? "0$callMinute" : "$callMinute";
      var second = callSecond < 10 ? "0$callSecond" : "$callSecond";
      if(callHour==0){
        state.callTime.value = "$hour:$minute:$second";
        state.callTimeNum.value = "$callHour and $callMinute minute and $callSecond second";
      }
    });
  }
}
