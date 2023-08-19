import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foton/common/values/colors.dart';
import 'package:foton/pages/message/voice_call/controller.dart';
import 'package:get/get.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_bg,
      body: SafeArea(
        child: Obx(() => Container(
              child: Stack(
                children: [
                  Positioned(
                      top: 10.h,
                      left: 30.w,
                      right: 30.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Text("${controller.state.callTime.value}",
                                style: TextStyle(
                                    color: AppColors.primaryElement,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.normal)),
                          ),
                          Container(
                            width: 70.h,
                            height: 70.h,
                            margin: EdgeInsets.only(top: 150.h),
                            child: Image.network(
                                "${controller.state.toAvatar.value}"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              controller.state.toName.value,
                              style: TextStyle(
                                  color: AppColors.primaryElementText,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.sp),
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                    bottom: 80.h,
                      left: 30.w,
                      right: 30.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(15.w),
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30.w)),
                                color: controller.state.openMicrophone.value ? AppColors.primaryElementText : AppColors.primaryText
                              ),
                              child: controller.state.openMicrophone.value ? Image.asset("assets/icons/b_microphone.png") : Image.asset("assets/icons/a_microphone.png"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: Text("Microphone",style: TextStyle(color: AppColors.primaryElementText,fontSize: 12.sp,fontWeight: FontWeight.normal),),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: controller.state.isJoined.value ? controller.leaveChannel : controller.joinChannel,
                            child: Container(
                              padding: EdgeInsets.all(15.w),
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30.w)),
                                  color: controller.state.isJoined.value ? AppColors.primaryElementBg : AppColors.primaryElementStatus
                              ),
                              child: controller.state.isJoined.value ? Image.asset("assets/icons/a_phone.png") : Image.asset("assets/icons/a_telephone.png"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: Text(controller.state.isJoined.value  ? "Disconnect" : "Connect",style: TextStyle(color: AppColors.primaryElementText,fontSize: 12.sp,fontWeight: FontWeight.normal),),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(15.w),
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30.w)),
                                  color: controller.state.enableSpeaker.value ? AppColors.primaryElementText : AppColors.primaryText
                              ),
                              child: controller.state.enableSpeaker.value ? Image.asset("assets/icons/b_trumpet.png") : Image.asset("assets/icons/a_trumpet.png"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: Text("Speaker",style: TextStyle(color: AppColors.primaryElementText,fontSize: 12.sp,fontWeight: FontWeight.normal),),
                          )
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            )),
      ),
    );
  }
}
