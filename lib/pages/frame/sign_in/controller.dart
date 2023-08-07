import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foton/common/apis/apis.dart';
import 'package:foton/common/entities/entities.dart';
import 'package:foton/common/store/store.dart';
import 'package:foton/common/widgets/toast.dart';
import 'package:foton/pages/frame/sign_in/state.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/routes/names.dart';

class SignInController extends GetxController {
  SignInController();

  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['openid']);

  Future<void> handleSignIn(String type) async {
    try {
      switch (type) {
        case "Google":

          var user = await _googleSignIn.signIn();

          if (user != null) {
            String? displayName = user.displayName;
            String email = user.email;
            String id = user.id;
            String photoUrl = user.photoUrl ?? "assets/icons/google.png";
            LoginRequestEntity loginPanelListRequestEntity =
                LoginRequestEntity();
            loginPanelListRequestEntity.avatar = photoUrl;
            loginPanelListRequestEntity.name = displayName;
            loginPanelListRequestEntity.email = email;
            loginPanelListRequestEntity.open_id = id;
            loginPanelListRequestEntity.type = 2;
            asyncPostData(loginPanelListRequestEntity);
          }
          break;
        case "Facebook":
          if (kDebugMode) {
            print("... you are logging in with facebook");
          }
          break;
        case "Apple":
          if (kDebugMode) {
            print("... you are logging in with apple");
          }
          break;
        default:
          if (kDebugMode) {
            print("... you are logging in with phone number");
          }
      }
    } catch (e) {
      if (kDebugMode) {
        print("... error with login $e");
      }
    }
  }

  asyncPostData(LoginRequestEntity loginRequestEntity) async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    var response = await UserAPI.Login(params: loginRequestEntity);
    if(response.code==0){
      await UserStore.to.saveProfile(response.data!);
      EasyLoading.dismiss();
    }else{
      EasyLoading.dismiss();
      toastInfo(msg: "Internet Error");
    }
    Get.offAllNamed(AppRoutes.Message);
  }
}
