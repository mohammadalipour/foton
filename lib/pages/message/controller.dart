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
    _snapshots();
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

  asyncLoadMsgData() async {
    print("-----------state.msgList.value");
    print(state.msgList.value);
    var token = UserStore.to.profile.token;

    var from_messages = await db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .where("from_token", isEqualTo: token)
        .get();
    print(from_messages.docs.length);

    var to_messages = await db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .where("to_token", isEqualTo: token)
        .get();
    print("to_messages.docs.length------------");
    print(to_messages.docs.length);
    state.msgList.clear();

    if (from_messages.docs.isNotEmpty) {
      await addMessage(from_messages.docs);
    }
    if (to_messages.docs.isNotEmpty) {
      await addMessage(to_messages.docs);
    }
    // sort
    state.msgList.value.sort((a, b) {
      if (b.last_time == null) {
        return 0;
      }
      if (a.last_time == null) {
        return 0;
      }
      return b.last_time!.compareTo(a.last_time!);
    });
  }

  _snapshots() async {
    var token = UserStore.to.profile.token;
    print("token--------");
    print(token);

    final toMessageRef = db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .where("to_token", isEqualTo: token);
    final fromMessageRef = db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .where("from_token", isEqualTo: token);
    toMessageRef.snapshots().listen(
          (event) async {
        print("snapshotslisten-----------");
        print(event.metadata.isFromCache);
        await asyncLoadMsgData();
        // if(!event.metadata.isFromCache){
        //
        // }
        print("snapshotslisten-----------");
      },
      onError: (error) => print("Listen failed: $error"),
    );
    fromMessageRef.snapshots().listen(
          (event) async {
        print("snapshotslisten-----------");
        print(event.metadata.isFromCache);
        await asyncLoadMsgData();
        print("snapshotslisten-----------");
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  addMessage(List<QueryDocumentSnapshot<Msg>> data) async {
    data.forEach((element) {
      var item = element.data();
      Message message = new Message();
      message.doc_id = element.id;
      message.last_time = item.last_time;
      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;
      if (item.from_token == token) {
        message.name = item.to_name;
        message.avatar = item.to_avatar;
        message.token = item.to_token;
        message.online = item.to_online;
        message.msg_num = item.to_msg_num ?? 0;
      } else {
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.token = item.from_token;
        message.online = item.from_online;
        message.msg_num = item.from_msg_num ?? 0;
      }
      state.msgList.add(message);
    });
  }
}
