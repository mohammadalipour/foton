import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/values/colors.dart';
import 'controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        controller.imgFromGallery();
                        Get.back();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      controller.imgFromCamera();
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildLogo(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 120.w,
        height: 120.w,
        margin: EdgeInsets.only(top: 0.h, bottom: 50.h),
        decoration: BoxDecoration(
          color: AppColors.primarySecondaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(60.w)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: CachedNetworkImage(
            imageUrl: controller.state.profileDetail.value.avatar!,
            height: 120.w,
            width: 120.w,
            imageBuilder: (context, imageProvider) =>
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60.w)),
                    image:
                    DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                )),
      ),
      Positioned(
          bottom: 50.w,
          right: 0.w,
          height: 35.w,
          child: GestureDetector(
              child: Container(
                height: 35.w,
                width: 35.w,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryElement,
                  borderRadius: BorderRadius.all(Radius.circular(40.w)),
                ),
                child: Image.asset(
                  "assets/icons/edit.png",
                ),
              ),
              onTap: () {
                _showPicker(context);
              }))
    ]);
  }

  Widget _buildCompleteBtn() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(top: 60.h, bottom: 30.h),
          padding: EdgeInsets.all(0.h),
          decoration: BoxDecoration(
            color: AppColors.primaryElement,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "Complete",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryElementText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          controller.goSave();
        });
  }

  Widget _buildLogoutBtn() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(top: 0.h, bottom: 30.h),
          padding: EdgeInsets.all(0.h),
          decoration: BoxDecoration(
            color: AppColors.primarySecondaryElementText,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "Logout",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryElementText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Get.defaultDialog(
            title: "Are you sure to log out?",
            content: Container(),
            onConfirm: () {
              controller.goLogout();
            },
            onCancel: () {},
            textConfirm: "Confirm",
            textCancel: "Cancel",
          );
        });
  }

  Widget _buildNameInput() {
    return Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(bottom: 20.h, top: 0.h),
        padding: EdgeInsets.all(0.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          keyboardType: TextInputType.multiline,
          controller: controller.NameEditingController,
          decoration: InputDecoration(
            hintText: controller.state.profileDetail.value.name,
            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            hintStyle: TextStyle(
              color: AppColors.primarySecondaryElementText,
            ),
          ),
          style: TextStyle(
            color: AppColors.primaryText,
            fontFamily: "Avenir",
            fontWeight: FontWeight.normal,
            fontSize: 14.sp,
          ),
          maxLines: 1,
          onChanged: (value) {
            controller.state.profileDetail.value.name = value;
          },
          autocorrect: false,
          obscureText: false,
        ));
  }

  Widget _buildDescripeInput() {
    return Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(bottom: 20.h, top: 0.h),
        padding: EdgeInsets.all(0.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          keyboardType: TextInputType.multiline,
          controller: controller.DescriptionEditingController,
          decoration: InputDecoration(
            hintText: controller.state.profileDetail.value.description == null
                ? "Enter a description"
                : controller.state.profileDetail.value.description,
            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            hintStyle: TextStyle(
              color: AppColors.primarySecondaryElementText,
            ),
          ),
          style: TextStyle(
            color: AppColors.primaryText,
            fontFamily: "Avenir",
            fontWeight: FontWeight.normal,
            fontSize: 14.sp,
          ),
          maxLines: 1,
          onChanged: (value) {
            controller.state.profileDetail.value.description = value;
          },
          autocorrect: false,
          obscureText: false,
        ));
  }

  Widget _buildSeleteStatusInput() {
    return Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(bottom: 20.h, top: 0.h),
        padding: EdgeInsets.all(0.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              margin: EdgeInsets.only(left: 15.w),
              decoration: BoxDecoration(
                color: controller.state.profileDetail.value.online == 1
                    ? AppColors.primaryElementStatus
                    : AppColors.primarySecondaryElementText,
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
              ),
            ),
            Container(
                width: 200.w,
                height: 44.h,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: controller.state.profileDetail.value.online == 1
                        ? "Online"
                        : "Offline",
                    hintStyle:
                    TextStyle(color: AppColors.primarySecondaryElementText),
                    contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  autocorrect: false,
                  obscureText: false,
                )),
            Container(
              width: 50.w,
              height: 30.w,
              padding: EdgeInsets.only(left: 0.w),
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 2.w,
                        color: AppColors.primarySecondaryBackground),
                  )),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 35,
                      iconEnabledColor: AppColors.primarySecondaryElementText,
                      hint: Text(''),
                      elevation: 0,
                      isExpanded: true,
                      // underline:Container(),
                      items: [
                        DropdownMenuItem(child: Text('Online'), value: 1),
                        DropdownMenuItem(child: Text('Offline'), value: 2),
                      ],
                      onChanged: (value) {
                        controller.state.profileDetail.value.online = value;
                        controller.state.profileDetail.refresh();
                      })),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: Obx(() =>
            SafeArea(
              child: CustomScrollView(slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.w,
                    horizontal: 15.w,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 0.h, top: 0.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildLogo(context),
                          _buildNameInput(),
                          _buildDescripeInput(),
                          _buildSeleteStatusInput(),
                          _buildCompleteBtn(),
                          _buildLogoutBtn()
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            )));
  }
}
