import 'package:flutter/foundation.dart';
import 'package:foton/common/entities/entities.dart';
import 'package:foton/pages/frame/sign_in/state.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/routes/names.dart';

class SignInController extends GetxController {
  SignInController();
  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'openid'
    ]
  );

  Future<void> handleSignIn(String type) async {
    try{
        switch(type){
          case "google":
            var user = await _googleSignIn.signIn();
            if(user!=null){
              String? displayName = user.displayName;
              String email = user.email;
              String id = user.id;
              String photoUrl = user.photoUrl ?? "assets/icons/google.png";
              LoginRequestEntity loginPanelListRequestEntity = LoginRequestEntity();
              loginPanelListRequestEntity.avatar = photoUrl;
              loginPanelListRequestEntity.name = displayName;
              loginPanelListRequestEntity.email = email;
              loginPanelListRequestEntity.open_id = id;
              loginPanelListRequestEntity.type = 2;
              asyncPostData();

            }
            break;
          case "facebook":
            if(kDebugMode){
              print("... you are logging in with facebook");
            }
            break;
          case "apple":
            if(kDebugMode){
              print("... you are logging in with apple");
            }
            break;
          default:
            if(kDebugMode){
              print("... you are logging in with phone number");
            }
        }
    }catch(e){
      if(kDebugMode) {
        print("... error with login $e");
      }
    }
  }

  asyncPostData(){
    Get.offAllNamed(AppRoutes.Message);
  }
}
