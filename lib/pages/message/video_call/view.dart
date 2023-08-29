import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foton/common/values/colors.dart';
import 'package:get/get.dart';

import 'controller.dart';

class VideoCallPage extends GetView<VideoCallController> {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_bg,
      body: SafeArea(
          child: Obx(
        () => Container(
          child: controller.state.isReadyPreview.value
              ? Stack(
            children: [
              controller.state.onRemoteUID.value==0?Container():AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.engine,
                  canvas: VideoCanvas(uid: controller.state.onRemoteUID.value),
                  connection: RtcConnection(channelId: controller.state.channelId.value),
                ),
              ),
              Positioned(
                top: 30.h,
                right: 15.w,
                child: SizedBox(
                  width: 80.w,
                  height: 120.w,
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: controller.engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),
              controller.state.isShowAvatar.value?Container():Positioned(
                  top: 10.h,
                  left: 30.w,
                  right: 30.w,
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top:6.h),
                          child: Text("${controller.state.callTime.value}",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                            ),),),
                      ])),
              controller.state.isShowAvatar.value?Positioned(
                  top: 10.h,
                  left: 30.w,
                  right: 30.w,
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top:6.h),
                          child: Text("${controller.state.callTime.value}",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                            ),),),
                        Container(
                          width: 70.w,
                          height: 70.w,
                          margin: EdgeInsets.only(top:150.h),
                          padding: EdgeInsets.all(0.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryElementText,
                            borderRadius: BorderRadius.all(Radius.circular(10.w)),
                          ),
                          child: Image.network("${controller.state.toAvatar.value}",fit: BoxFit.fill,),),
                        Container(
                          margin: EdgeInsets.only(top:6.h),
                          child: Text("${controller.state.toName.value}",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                            ),),)
                      ])):Container(),
              Positioned(
                  bottom: 80.h,
                  left: 30.w,
                  right: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        GestureDetector(child: Container(
                          width: 60.w,
                          height: 60.w,
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: controller.state.isJoined.value ? AppColors.primaryElementBg:AppColors.primaryElementStatus,
                            borderRadius: BorderRadius.all(Radius.circular(30.w)),
                          ),
                          child: controller.state.isJoined.value ?Image.asset("assets/icons/a_phone.png"):Image.asset("assets/icons/a_telephone.png"),
                        ),
                          onTap: controller.state.isJoined.value ? controller.leaveChannel : controller.joinChannel,
                        ),
                        Container(
                          margin: EdgeInsets.only(top:10.h),
                          child: Text(controller.state.isJoined.value?"Disconnect":"Connected",style: TextStyle(
                            color: AppColors.primaryElementText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                          ),),),
                      ]),
                      Column(children: [
                        GestureDetector(child: Container(
                          width: 60.w,
                          height: 60.w,
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: controller.state.switchCameras.value?AppColors.primaryElementText:AppColors.primaryText,
                            borderRadius: BorderRadius.all(Radius.circular(30.w)),
                          ),
                          child: controller.state.switchCameras.value?Image.asset("assets/icons/b_photo.png"):Image.asset("assets/icons/a_photo.png"),
                        ),
                          onTap: controller.switchCamera,),
                        Container(
                          margin: EdgeInsets.only(top:10.h),
                          child: Text("switchCamera",style: TextStyle(
                            color: AppColors.primaryElementText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                          ),),)
                      ]),
                    ],))
            ],
          ):Container(),
            )
  )));
  }
}
