import 'package:foton/pages/frame/welcome/state.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController{
  WelcomeController();
  final title = "Foton .";
  final state = WelcomeState();

  @override
  void onReady(){
    super.onReady();
    print("welcomeController");
  }
}