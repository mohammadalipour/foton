import 'package:foton/common/routes/names.dart';
import 'package:foton/common/store/store.dart';
import 'package:foton/pages/profile/state.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileController extends GetxController {
  ProfileController();

  final state = ProfileState();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(
      const Duration(seconds: 3), ()=> Get.offAllNamed(AppRoutes.Message)
    );
  }

  Future<void> goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }
}
