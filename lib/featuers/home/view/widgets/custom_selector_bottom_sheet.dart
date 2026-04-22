import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSelectorBottomSheet extends StatelessWidget {
  final String title;
  final List<String> options;

  const CustomSelectorBottomSheet({super.key, required this.title, required this.options});

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required List<String> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomSelectorBottomSheet(title: title, options: options),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorManager.primary, width: 1.w),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorManager.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              title,
              style: getBoldStyle(color: ColorManager.black, fontSize: 18.sp),
            ),
          ),
          SizedBox(height: 16.h),

          // Options List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: options.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: ColorManager.primary,
                indent: 0,
                endIndent: 0,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.pop(context, options[index]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          options[index],
                          style: getMediumStyle(color: ColorManager.black, fontSize: 14.sp),
                        ),
                        Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ColorManager.primary, width: 1.w),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.r,
                            color: ColorManager.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
