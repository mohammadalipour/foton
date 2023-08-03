import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Sign IN Page"),
      ),
    );
  }
}
