import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foton/common/apis/apis.dart';
import 'package:foton/common/entities/contact.dart';
import 'package:foton/common/store/store.dart';
import 'package:foton/pages/contact/state.dart';
import 'package:get/get.dart';

import '../../common/entities/msg.dart';

class ContactController extends GetxController {
  ContactController();

  final title = "Foton .";
  final state = ContactState();
  final token = UserStore.to.profile.token;
  final db = FirebaseFirestore.instance;

  @override
  void onReady() async {
    super.onReady();
    asyncLoadAllData();
  }

  Future<void> goChat(ContactItem contactItem) async {
    var fromMessages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: token)
        .where("to_token", isEqualTo: contactItem.token)
        .get();

    var toMessages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: contactItem.token)
        .where("to_token", isEqualTo: token)
        .get();

    if (fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
      var profile = UserStore.to.profile;
      var msgData = Msg(
          from_token: profile.token,
          to_token: contactItem.token,
          from_name: profile.name,
          to_name: contactItem.name,
          from_avatar: profile.avatar,
          to_avatar: contactItem.avatar,
          from_online: profile.online,
          to_online: contactItem.online,
          last_msg: "",
          last_time: Timestamp.now(),
          msg_num: 0);

      var docId = await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .add(msgData);

      Get.offAllNamed("/chat",parameters: {
        "doc_id": docId.id,
        "to_token":contactItem.token??"",
        "to_name":contactItem.name??"",
        "to_avatar":contactItem.avatar??"",
        "to_online":contactItem.online.toString(),

      });

    }else{
      if(fromMessages.docs.isNotEmpty){
        Get.toNamed("/chat",parameters: {
          "doc_id": fromMessages.docs.first.id,
          "to_token":contactItem.token??"",
          "to_name":contactItem.name??"",
          "to_avatar":contactItem.avatar??"",
          "to_online":contactItem.online.toString(),

        });
      }

      if(toMessages.docs.isNotEmpty){
        Get.toNamed("/chat",parameters: {
          "doc_id": toMessages.docs.first.id,
          "to_token":contactItem.token??"",
          "to_name":contactItem.name??"",
          "to_avatar":contactItem.avatar??"",
          "to_online":contactItem.online.toString(),

        });
      }
    }
  }

  asyncLoadAllData() async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    state.contactList.clear();
    var result = await ContactAPI.post_contact();
    if (kDebugMode) {
      print(result.data!);
    }
    if (result.code == 0) {
      state.contactList.addAll(result.data!);
    }
    EasyLoading.dismiss();
  }
}
