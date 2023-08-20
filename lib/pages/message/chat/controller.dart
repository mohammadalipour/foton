import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:foton/common/entities/entities.dart';
import 'package:foton/common/store/store.dart';
import 'package:foton/pages/message/chat/state.dart';
import 'package:get/get.dart';

import '../../../common/routes/names.dart';

class ChatController extends GetxController {
  ChatController();

  final state = ChatState();
  late String docId;
  final myInputController = TextEditingController();
  final token = UserStore.to.profile.token;
  final db = FirebaseFirestore.instance;
  var listener;

  void goMore() {
    state.moreStatus.value = state.moreStatus.value ? false : true;
  }

  void audioCall() {
    state.moreStatus.value = false;
    Get.toNamed(AppRoutes.VoiceCall, parameters: {
      "to_token": state.toToken.value,
      "to_name": state.toName.value,
      "to_avatar": state.toAvatar.value,
      "call_role": "anchor",
      "doc_id": docId
    });
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    print(data);
    docId = data['doc_id']!;
    state.toToken.value = data['to_token'] ?? "";
    state.toName.value = data['to_name'] ?? "";
    state.toAvatar.value = data['to_avatar'] ?? "";
    state.toOnline.value = data['to_online'] ?? "1";
  }

  @override
  void onClose() {
    super.onClose();
    listener.cancel();
    myInputController.dispose();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    state.msgContentList.clear();
    final messages = db
        .collection("message")
        .doc(docId)
        .collection("msg_list")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .orderBy("added_time", descending: true)
        .limit(15);

    listener = messages.snapshots().listen((event) {
      List<Msgcontent> tempMsgList = <Msgcontent>[];
      for (var change in event.docChanges){
        switch (change.type) {
          case DocumentChangeType.added:
            if(change.doc.data()!=null){
              tempMsgList.add(change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
      tempMsgList.reversed.forEach((element){
        state.msgContentList.value.insert(0, element);
      });

      state.msgContentList.refresh();


    });

  }

  Future<void> sendMessage() async {
    String sendContent = myInputController.text;
    final content = Msgcontent(
        token: token,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now());

    await db
        .collection("message")
        .doc(docId)
        .collection("msg_list")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      myInputController.clear();
    });

    var messageResult = await db
        .collection("message")
        .doc(docId)
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .get();

    if (messageResult.data() != null) {
      var item = messageResult.data()!;
      int toMessageNum = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int fromMessageNum = item.to_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == token) {
        fromMessageNum = fromMessageNum + 1;
      } else {
        toMessageNum = toMessageNum + 1;
      }

      await db.collection("message").doc(docId).update({
        "to_msg_num": toMessageNum,
        "from_msg_num": fromMessageNum,
        "last_msg": sendContent,
        "last_time": Timestamp.now(),
      });
    }
  }
}
