import 'dart:io';
import 'package:foton/common/apis/apis.dart';
import 'package:foton/common/services/services.dart';
import 'package:flutter/material.dart';
import 'package:foton/common/store/store.dart';
import 'package:foton/pages/profile/state.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'index.dart';

import '../../common/apis/chat.dart';
import '../../common/apis/user.dart';
import '../../common/entities/user.dart';
import '../../common/widgets/toast.dart';


class ProfileController extends GetxController {
  final state = ProfileState();
  TextEditingController? NameEditingController = TextEditingController();
  TextEditingController? DescriptionEditingController = TextEditingController();
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  ProfileController();

  goSave() async{
    if(state.profileDetail.value.name==null || state.profileDetail.value.name!.isEmpty){
      toastInfo(msg: "name not empty!");
      return;
    }
    if(state.profileDetail.value.description==null || state.profileDetail.value.description!.isEmpty){
      toastInfo(msg: "description not empty!");
      return;
    }
    if(state.profileDetail.value.avatar==null || state.profileDetail.value.avatar!.isEmpty){
      toastInfo(msg: "avatar not empty!");
      return;
    }

    LoginRequestEntity updateProfileRequestEntity = new LoginRequestEntity();
    var userItem = state.profileDetail.value;
    updateProfileRequestEntity.avatar = userItem.avatar;
    updateProfileRequestEntity.name = userItem.name;
    updateProfileRequestEntity.description = userItem.description;
    updateProfileRequestEntity.online = userItem.online;

    var result = await UserAPI.UpdateProfile(params: updateProfileRequestEntity);
    print(result.code);
    print(result.msg);
    if(result.code==0) {
      UserItem userItem = state.profileDetail.value;
      await UserStore.to.saveProfile(userItem);
      Get.back(result:"finish");
    }




  }

  goLogout() async{
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print('No image selected.');
    }

  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile() async {
    // if (_photo == null) return;
    // print(_photo);
    var result = await ChatAPI.upload_img(file:_photo);
    print(result.data);
    if(result.code==0){

      state.profileDetail.value.avatar = result.data;
      state.profileDetail.refresh();
    }else{
      toastInfo(msg: "image error");
    }
  }

  asyncLoadAllData() async {
    // await
  }

  @override
  void onInit() {
    super.onInit();
    var userItem = Get.arguments;
    if(userItem!=null){
      state.profileDetail.value = userItem;
      if(state.profileDetail.value.name!=null){
        NameEditingController?.text = state.profileDetail.value.name!;
      }
      if(state.profileDetail.value.description!=null){
        DescriptionEditingController?.text = state.profileDetail.value.description!;
      }
    }

  }
  @override
  void onReady() {
    super.onReady();

  }

  @override
  void dispose() {
    super.dispose();
  }
}