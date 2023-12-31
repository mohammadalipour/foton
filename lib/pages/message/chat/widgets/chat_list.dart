import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foton/common/values/colors.dart';
import 'package:foton/pages/message/chat/controller.dart';
import 'package:get/get.dart';

import 'chat_left_list.dart';
import 'chat_right_list.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: AppColors.primaryBackground,
          padding: EdgeInsets.only(bottom: 100.h),
          child: GestureDetector(
            child: CustomScrollView(
              controller: controller.myScrollController,
              reverse: true,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var item = controller.state.msgContentList[index];
                      if (controller.token == item.token) {
                        return ChatRightList(item);
                      }
                      return ChatLeftList(item);
                    }, childCount: controller.state.msgContentList.length),
                  ),
                ),
                SliverPadding(padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverToBoxAdapter(
                    child: controller.state.isLoading.value ? Align(alignment: Alignment.center,child: Text("Loading ... ")): Container(),
                  ),
                ),
              ],
            ),
            onTap: (){
              controller.closeAllPop();
            },
          ),
        ));
  }
}
