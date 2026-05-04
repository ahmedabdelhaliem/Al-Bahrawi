import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildSectionTitle("اليوم"),
                _buildNotificationCard(
                  title: "تم الرد على طلبك",
                  desc: "تم تحديد التكلفة التقديرية لطلب الاستشارة الخاص بك",
                  icon: Icons.notifications_active_rounded,
                  iconColor: ColorManager.white,
                  bgColor: ColorManager.primary,
                  onTap: () => context.push(AppRouters.myCases),
                ),
                _buildNotificationCard(
                  title: "تحديث في الطلب",
                  desc: "المستشار أضاف ملاحظات جديدة على طلبك",
                  icon: Icons.confirmation_number_rounded,
                  iconColor: ColorManager.blue,
                  bgColor: ColorManager.blue.withValues(alpha: 0.05),
                  onTap: () => context.push(AppRouters.myCases),
                ),
                SizedBox(height: 10.h),
                _buildSectionTitle("أمس"),
                _buildNotificationCard(
                  title: "طلب جديد",
                  desc: "تم استلام طلب الاستشارة بنجاح وهو قيد المراجعة",
                  icon: Icons.grid_view_rounded,
                  iconColor: ColorManager.grey,
                  bgColor: ColorManager.grey.withValues(alpha: 0.05),
                  onTap: () => context.push(AppRouters.myCases),
                ),
                SizedBox(height: 10.h),
                _buildSectionTitle("20 نوفمبر 2025"),
                _buildNotificationCard(
                  title: "مرحباً بك",
                  desc: "أهلاً بك في تطبيق البحراوي للاستشارات",
                  icon: Icons.grid_view_rounded,
                  iconColor: ColorManager.grey,
                  bgColor: ColorManager.grey.withValues(alpha: 0.05),
                  onTap: () => context.push(AppRouters.myCases),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 55.h, bottom: 40.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: ColorManager.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                AppStrings.notifications.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Text(
        title,
        style: getBoldStyle(color: ColorManager.blue, fontSize: 14.sp),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: ColorManager.primary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.w),
        child: Icon(Icons.delete_outline_rounded,
            color: ColorManager.white, size: 24.w),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style:
                          getBoldStyle(color: ColorManager.blue, fontSize: 15.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      desc,
                      style: getRegularStyle(
                          color: ColorManager.greyText, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
