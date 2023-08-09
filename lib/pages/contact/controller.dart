import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foton/common/apis/apis.dart';
import 'package:foton/pages/contact/state.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  ContactController();

  final title = "Foton .";
  final state = ContactState();

  @override
  void onReady() async {
    super.onReady();
    asyncLoadAllData();
  }

  asyncLoadAllData() async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap:true
    );
    state.contactList.clear();
    var result = await ContactAPI.post_contact();
    if (kDebugMode) {
      print(result.data!);
    }
    if(result.code==0){
      state.contactList.addAll(result.data!);
    }
    EasyLoading.dismiss();
  }
}
