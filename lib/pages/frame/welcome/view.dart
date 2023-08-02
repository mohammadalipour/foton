import 'package:flutter/material.dart';
import 'package:foton/common/values/colors.dart';
import 'package:foton/pages/frame/welcome/controller.dart';
import 'package:get/get.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({Key? key}) : super(key: key);

  Widget _buildPageHeadTitle(String title){
    return Container(
      margin: EdgeInsets.only(top: 350),
      child:  Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.primaryElementText,
          fontFamily: "Montserrat",
          fontSize: 45
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryElement,
      body: Container(
        width: 360,
        height: 780,
        child: _buildPageHeadTitle(controller.title),
      ),
    );
  }
}
