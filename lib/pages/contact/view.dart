import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foton/pages/contact/widgets/contact_list.dart';
import 'package:get/get.dart';

import '../../common/values/colors.dart';
import 'controller.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
        title: Text(
      "Contact",
      style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        width: 360.w,
        height: 780.h,
        child: const Center(
          child: ContactList(),
        ),
      ),
    );
  }
}
