import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/entities/msgcontent.dart';
import '../../../../common/values/colors.dart';


Widget ChatLeftList(Msgcontent item) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.w,horizontal: 20.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250.w, minHeight: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(

                decoration: BoxDecoration(
                    color: AppColors.primaryThreeElementText,
                    borderRadius: BorderRadius.all(Radius.circular(5.w))
                ),
                padding: EdgeInsets.only(
                    top: 10.w,
                    bottom: 10.w,
                    left: 10.w,
                    right: 10.w
                ),
                child: item.type == 'text'
                    ? Text(
                  "${item.content!}",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primaryElementText
                  ),
                )
                    : Text("image"),
              )
            ],
          ),
        )
      ],
    ),
  );
}