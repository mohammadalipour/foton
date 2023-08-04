import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foton/common/routes/pages.dart';
import 'package:foton/common/style/style.dart';
import 'package:get/get.dart';

import 'global.dart';

Future<void> main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 780),
        builder: (context, child) =>
            GetMaterialApp(
              title: 'Foton',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
            ));
  }
}
