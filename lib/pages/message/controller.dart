import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foton/common/entities/base.dart';
import 'package:foton/common/routes/routes.dart';
import 'package:foton/pages/message/state.dart';
import 'package:get/get.dart';

import '../../common/apis/chat.dart';
import '../../common/entities/message.dart';
import '../../common/entities/msg.dart';
import '../../common/store/user.dart';

class MessageController extends GetxController {
  MessageController();

  final state = MessageState();
  var db = FirebaseFirestore.instance;
  final token = UserStore.to.profile.token;

  Future<void> goProfile() async {
    await Get.toNamed(AppRoutes.Profile, arguments: state.headDetail.value);
  }

  @override
  void onReady() {
    super.onReady();
    firebaseMessageSetup();
  }

  firebaseMessageSetup() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("... my device token is $fcmToken");
    if (fcmToken != null) {
      BindFcmTokenRequestEntity bindFcmTokenRequestEntity =
      BindFcmTokenRequestEntity();
      bindFcmTokenRequestEntity.fcmtoken = fcmToken;
      await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
    _snapShot();
  }

  void getProfile() async {
    var profile = await UserStore.to.profile;
    state.headDetail.value = profile;
    state.headDetail.refresh();
  }

  goTabStatus() {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    state.tabStatus.value = !state.tabStatus.value;
    if (state.tabStatus.value) {
      asyncLoadMsgData();
    } else {}

    EasyLoading.dismiss();
  }

  void asyncLoadMsgData() async {
    var fromMessage = await db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_token", isEqualTo: token).get();

    if(fromMessage.docs.isNotEmpty){
      await addMessage(fromMessage.docs);
    }

    var toMessage = await db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("to_token", isEqualTo: token).get();

    if(toMessage.docs.isNotEmpty){
      await addMessage(toMessage.docs);
    }
  }

  _snapShot() {
    final toMessageReference = db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("to_token", isEqualTo: token);

    final fromMessageReference = db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_token", isEqualTo: token);

    toMessageReference.snapshots().listen((event) {
      asyncLoadMsgData();
    });

    fromMessageReference.snapshots().listen((event) {
      asyncLoadMsgData();
    });

  }

  addMessage(List<QueryDocumentSnapshot<Msg>> docs) {
    docs.forEach((element) {
      var item = element.data();
      Message message = Message();
      message.doc_id = element.id;
      message.last_time = item.last_time;
      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;
      if(item.from_token == token){
        message.name = item.to_name;
        message.avatar = item.to_avatar;
        message.token = item.to_token;
        message.online = item.to_online;
        message.msg_num = item.to_msg_num ?? 0;
      }else{
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.token = item.from_token;
        message.online = item.from_online;
        message.msg_num = item.from_msg_num ?? 0;
      }
    });
  }
}
