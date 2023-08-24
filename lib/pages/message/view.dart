import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foton/common/routes/routes.dart';
import 'package:get/get.dart';

import '../../common/values/colors.dart';
import 'controller.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  Widget _headBar() {
    return Center(
      child: Container(
        width: 320.w,
        height: 44.w,
        margin: EdgeInsets.only(bottom: 20.h, top: 20.h),
        child: Row(
          children: [
            Stack(
              children: [
                GestureDetector(
                  child: Container(
                    width: 44.h,
                    height: 44.h,
                    decoration: BoxDecoration(
                        color: AppColors.primarySecondaryBackground,
                        borderRadius: BorderRadius.all(Radius.circular(22.h)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1))
                        ]),
                    child: controller.state.headDetail.value.avatar == null
                        ? Image(
                            image:
                                AssetImage("assets/images/account_header.png"))
                        : CachedNetworkImage(
                            imageUrl:
                                controller.state.headDetail.value.avatar!,
                            width: 44.w,
                            height: 44.w,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22.w)),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.fill)),
                            ),
                            errorWidget: (context, url, error) => Image(
                              image: AssetImage(
                                  'assets/images/account_header.png'),
                            ),
                          ),
                  ),
                  onTap: () {
                    controller.goProfile();
                  },
                ),
                Positioned(
                    bottom: 5.w,
                    right: 0.w,
                    height: 14.w,
                    child: Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.w, color: AppColors.primaryElementText),
                          color: AppColors.primaryElementStatus,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.w))),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _headTabs() {
    return Center(
      child: Container(
        height: 48.h,
        width: 320.w,
        decoration: const BoxDecoration(
            color: AppColors.primarySecondaryBackground,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.all(4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: (){
                controller.goTabStatus();
              },
              child: Container(
                width: 150.w,
                height: 40.h,
                decoration: controller.state.tabStatus.value ?
                BoxDecoration(
                    color: AppColors.primaryBackground,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2))
                    ]) : BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Chat",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.primaryThreeElementText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                controller.goTabStatus();
              },
              child: Container(
                width: 150.w,
                height: 40.h,
                decoration: controller.state.tabStatus.value ? BoxDecoration(): BoxDecoration(
                    color: AppColors.primaryBackground,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Call",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.primaryThreeElementText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SafeArea(
              child: Stack(
            children: [
              CustomScrollView(slivers: [
                SliverAppBar(
                  pinned: true,
                  title: _headBar(),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverToBoxAdapter(
                    child: _headTabs(),
                  ),
                ),
                SliverPadding(padding: EdgeInsets.symmetric(vertical: 0.w,horizontal: 0.w),
                  sliver: controller.state.tabStatus.value ? SliverList(delegate: SliverChildBuilderDelegate(
                      (context, index){
                        return Container(
                          width: 250,
                          height: 50,
                        );
                      },
                    childCount: controller.state.msgList.length
                  )): SliverToBoxAdapter(child: Container(),),
                  
                )
              ]),
              Positioned(
                  right: 20.w,
                  bottom: 70.w,
                  width: 50.w,
                  height: 50.w,
                  child: GestureDetector(
                    child: Container(
                      height: 50.w,
                      width: 50.w,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          color: AppColors.primaryElement,
                          borderRadius: BorderRadius.all(Radius.circular(40.w)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(1, 1)),
                          ]),
                      child: Image.asset("assets/icons/contact.png"),
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.Contact);
                    },
                  ))
            ],
          ))),
    );
  }
}
