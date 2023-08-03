import 'package:flutter/cupertino.dart';
import 'package:foton/common/services/services.dart';
import 'package:foton/common/store/store.dart';
import 'package:get/get.dart';

class Global{
   static Future init() async{
     WidgetsFlutterBinding.ensureInitialized();
     await Get.putAsync<StorageService>(() => StorageService().init());
     Get.put<UserStore>(UserStore());
   }
}