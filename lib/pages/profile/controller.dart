import 'package:foton/common/store/store.dart';
import 'package:foton/pages/profile/state.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileController extends GetxController {
  ProfileController();

  final state = ProfileState();

  Future<void> goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }

  @override
  void onInit(){
    super.onInit();
    var userItem = Get.arguments;
    if(userItem!=null){
      state.profileDetail.value = userItem;
    }
  }
}
