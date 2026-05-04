import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/features/profile/main%20profile/model/profile_data.dart';
import 'package:al_bahrawi/features/profile/main%20profile/cubit/logout_cubit.dart';
import 'package:al_bahrawi/features/profile/main%20profile/view/widgets/account_action_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xffF9FAFB),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                physics: const BouncingScrollPhysics(),
                children: [
                  ...List.generate(
                    ProfileData.profileItems.length,
                    (index) {
                      final item = ProfileData.profileItems[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                        child: AccountActionButton(
                          model: item,
                          onRefresh: () => setState(() {}),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  _buildLogoutButton(context),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return BlocConsumer<LogoutCubit, BaseState>(
      listener: (context, state) {
        if (state.status == Status.success) {
          instance<AppPreferences>().logout().then((_) {
            if (mounted) context.go(AppRouters.login);
          });
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: InkWell(
            onTap: () => context.read<LogoutCubit>().logout(),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: ColorManager.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: ColorManager.primary.withValues(alpha: 0.1), width: 1),
              ),
              child: state.status == Status.loading
                  ? Center(child: SizedBox(width: 24.w, height: 24.w, child: CircularProgressIndicator(strokeWidth: 2, color: ColorManager.primary)))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.logout.tr(),
                          style: getBoldStyle(color: ColorManager.primary, fontSize: 16.sp),
                        ),
                        SizedBox(width: 12.w),
                        Icon(Icons.logout_rounded, color: ColorManager.primary, size: 20.w),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 60.h, bottom: 40.h, left: 24.w, right: 24.w),
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
        children: [
          Text(
            AppStrings.profile.tr(),
            style: getBoldStyle(color: ColorManager.white, fontSize: 20.sp),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${AppStrings.hello.tr()} 👋",
                    style: getRegularStyle(
                        color: ColorManager.white.withValues(alpha: 0.8),
                        fontSize: 14.sp),
                  ),
                  Text(
                    instance<AppPreferences>().getUserName(),
                    style:
                        getBoldStyle(color: ColorManager.white, fontSize: 18.sp),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(3.r),
                    decoration: BoxDecoration(
                      color: ColorManager.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: ColorManager.white.withValues(alpha: 0.3),
                          width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 35.r,
                      backgroundColor: ColorManager.white,
                      backgroundImage: (instance<AppPreferences>().getUserImage()?.isNotEmpty == true &&
                                        instance<AppPreferences>().getUserImage()!.length > 40)
                          ? NetworkImage(instance<AppPreferences>().getUserImage()!)
                          : null,
                      child: (instance<AppPreferences>().getUserImage()?.isNotEmpty == true &&
                              instance<AppPreferences>().getUserImage()!.length > 40)
                          ? null
                          : Icon(Icons.person,
                              color: ColorManager.blue, size: 35.w),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await context.push(AppRouters.myAccount);
                      if (result == true) {
                        setState(() {}); // Refresh UI with new data from AppPrefs
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: ColorManager.gold,
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorManager.white, width: 1.5),
                      ),
                      child: Icon(Icons.edit_rounded, color: ColorManager.white, size: 12.w),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
