import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:foton/common/services/services.dart';
import 'package:foton/common/store/store.dart';
import 'package:foton/firebase_options.dart';
import 'package:get/get.dart';

class Global{
   static Future init() async{
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     await Get.putAsync<StorageService>(() => StorageService().init());
     Get.put<ConfigStore>(ConfigStore());
     Get.put<UserStore>(UserStore());
   }
}