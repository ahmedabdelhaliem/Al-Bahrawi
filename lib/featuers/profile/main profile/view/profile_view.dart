import 'package:base_project/featuers/profile/main%20profile/model/profile_data.dart';
import 'package:base_project/featuers/profile/main%20profile/cubit/logout_cubit.dart';
import 'package:base_project/featuers/profile/main%20profile/view/widgets/account_action_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/resources/color_manager.dart';
import '../../../../common/resources/strings_manager.dart';
import '../../../../common/resources/styles_manager.dart';

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
        backgroundColor: ColorManager.white,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            SliverAppBar(
              centerTitle: true,
              title: Text(
                AppStrings.myAccount.tr(),
                style: getSemiBoldStyle(
                  fontSize: 20,
                  color: ColorManager.black,
                ),
              ),
            ),
            // _buildHeader(),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = ProfileData.profileItems[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: AccountActionButton(model: item),
                );
              }, childCount: ProfileData.profileItems.length),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeader() {
  //   return SliverAppBar(
  //     floating: false,
  //     pinned: true,
  //     elevation: 0,
  //     expandedHeight: MediaQuery.sizeOf(context).height * .1,
  //     backgroundColor: Colors.transparent,
  //     automaticallyImplyLeading: false,
  //     flexibleSpace: FlexibleSpaceBar(
  //       background: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 15.w),
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: ColorManager.gradientPrimary,
  //           ),
  //         ),
  //         child: _header(),
  //       ),
  //     ),
  //   );
  // }

  // Widget _header() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * .04),
  //     child: Stack(
  //       alignment: AlignmentDirectional.centerStart,
  //       clipBehavior: Clip.none,
  //       children: [
  //         PositionedDirectional(
  //           start: 30.w,
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               _hello(),
  //               SizedBox(width: 5.w),
  //               _editButton(),
  //             ],
  //           ),
  //         ),
  //         _logo(),

  //         // Expanded(
  //         //   child: Column(
  //         //     crossAxisAlignment: CrossAxisAlignment.start,
  //         //     mainAxisSize: MainAxisSize.min,
  //         //     children: [
  //         //
  //         //       SizedBox(height: 10.h,),
  //         //       _languageButton(),
  //         //     ],
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _logo() {
  //   final userImage = instance<AppPreferences>().getUserImage();

  //   return Container(
  //     padding: EdgeInsets.all(3.r),
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: ColorManager.white.withValues(alpha: 0.2),
  //       border: Border.all(
  //         color: ColorManager.white.withValues(alpha: 0.3),
  //         width: 1,
  //       ),
  //     ),
  //     child: CircleAvatar(
  //       radius: 26.r,
  //       backgroundColor: ColorManager.white,
  //       backgroundImage: userImage == null
  //           ? null
  //           : NetworkImage(userImage) as ImageProvider,
  //       child: userImage == null
  //           ? Image.asset(ImageAssets.logo, width: 34.w, height: 34.w)
  //           : null,
  //     ),
  //   );
  // }

  // Widget _hello() {
  //   return Container(
  //     alignment: Alignment.center,
  //     padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 4.h),
  //     decoration: BoxDecoration(
  //       // borderRadius: BorderRadius.circular(10.r),
  //       color: ColorManager.white.withValues(alpha: 0.2),
  //       borderRadius: BorderRadius.circular(12.r),
  //       border: Border.all(
  //         color: ColorManager.white.withValues(alpha: 0.3),
  //         width: 1,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: ColorManager.primary.withValues(alpha: 0.2),
  //           blurRadius: 2.r,
  //           offset: Offset(0, 1.h),
  //         ),
  //       ],
  //     ),
  //     child: Text(
  //       "${AppStrings.hello.tr()} ... ${instance<AppPreferences>().getUserName()}",
  //       style: getBoldStyle(fontSize: 12.sp, color: ColorManager.white),
  //     ),
  //   );
  // }

  // Widget _editButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => BlocProvider(
  //             create: (context) => ProfileCubit(),
  //             child: const EditProfileView(),
  //           ),
  //         ),
  //       ).then((value) {
  //         setState(() {});
  //       });
  //     },
  //     child: Container(
  //       padding: EdgeInsets.all(8.w),
  //       decoration: BoxDecoration(
  //         color: ColorManager.white.withValues(alpha: 0.2),
  //         shape: BoxShape.circle,
  //         border: Border.all(
  //           color: ColorManager.white.withValues(alpha: 0.3),
  //           width: 1,
  //         ),
  //       ),
  //       child: Icon(Icons.edit_rounded, color: ColorManager.white, size: 14.r),
  //     ),
  //   );
  // }

  // Widget _buildMenuGrid() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //     child: Column(
  //       children: [
  //         _buildMenuItem(
  //           icon: IconAssets.language,
  //           title: AppStrings.changeLanguage.tr(),
  //           subtitle: language == "ar" ? "English" : "العربية",
  //           color: ColorManager.primary,
  //           onTap: () {
  //             instance<AppPreferences>().changeAppLanguage().then((value) {
  //               if (mounted) {
  //                 context.go(AppRouters.root);
  //               }
  //             });
  //           },
  //         ),
  //         SizedBox(height: 6.h),
  //         _buildMenuItem(
  //           icon: IconAssets.privacyPolicy,
  //           title: AppStrings.privacyPolicy.tr(),
  //           color: ColorManager.primary,
  //           onTap: () {
  //             AppFunctions.navigateTo(
  //               context,
  //               const PrivacyPolicyView(infoType: InfoType.privacyPolicy),
  //             );
  //           },
  //         ),
  //         SizedBox(height: 6.h),
  //         _buildMenuItem(
  //           icon: IconAssets.privacyPolicy,
  //           title: AppStrings.terms.tr(),
  //           color: ColorManager.primary,
  //           onTap: () {
  //             AppFunctions.navigateTo(
  //               context,
  //               const PrivacyPolicyView(infoType: InfoType.terms),
  //             );
  //           },
  //         ),
  //         SizedBox(height: 6.h),
  //         _buildMenuItem(
  //           icon: IconAssets.aboutUs,
  //           title: AppStrings.aboutUs.tr(),
  //           color: ColorManager.primary,
  //           onTap: () {
  //             AppFunctions.navigateTo(
  //               context,
  //               const PrivacyPolicyView(infoType: InfoType.aboutUs),
  //             );
  //           },
  //         ),
  //         SizedBox(height: 6.h),
  //         _buildMenuItem(
  //           icon: IconAssets.profile,
  //           title: AppStrings.contactUs.tr(),
  //           color: ColorManager.primary,
  //           onTap: () {
  //             AppFunctions.navigateTo(context, const ContactUsView());
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildMenuItem({
  //   required String icon,
  //   required String title,
  //   String? subtitle,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: BorderRadius.circular(14.r),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
  //         decoration: BoxDecoration(
  //           color: ColorManager.white.withValues(alpha: 0.7),
  //           borderRadius: BorderRadius.circular(12.r),
  //           border: Border.all(
  //             color: ColorManager.greyBorder.withValues(alpha: 0.2),
  //             width: 1,
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: ColorManager.black.withValues(alpha: 0.05),
  //               blurRadius: 10.r,
  //               offset: Offset(0, 2.h),
  //               spreadRadius: 0,
  //             ),
  //             BoxShadow(
  //               color: ColorManager.white,
  //               blurRadius: 0,
  //               offset: Offset(0, 0),
  //               spreadRadius: -1,
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 38.w,
  //               height: 38.w,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     color.withValues(alpha: 0.12),
  //                     color.withValues(alpha: 0.06),
  //                   ],
  //                 ),
  //                 borderRadius: BorderRadius.circular(10.r),
  //               ),
  //               child: Center(
  //                 child: SvgPicture.asset(
  //                   icon,
  //                   width: 18.w,
  //                   height: 18.w,
  //                   colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 10.w),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: getSemiBoldStyle(
  //                       fontSize: 12.sp,
  //                       color: ColorManager.textColor,
  //                     ),
  //                   ),
  //                   if (subtitle != null) ...[
  //                     SizedBox(height: 1.h),
  //                     Text(
  //                       subtitle,
  //                       style: getRegularStyle(
  //                         fontSize: 10.sp,
  //                         color: ColorManager.greyTextColor,
  //                       ),
  //                     ),
  //                   ],
  //                 ],
  //               ),
  //             ),
  //             Icon(
  //               Icons.arrow_forward_ios_rounded,
  //               color: ColorManager.greyTextColor.withValues(alpha: 0.4),
  //               size: 12.r,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildBottomActions() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //     child: Column(
  //       children: [
  //         BlocConsumer<LogoutCubit, BaseState<BaseModel>>(
  //           listener: (context, state) async {
  //             if (state.status == Status.success) {
  //               await instance<AppPreferences>().logout();
  //               if (mounted) {
  //                 context.go(AppRouters.login, extra: {"pageIndex": 3});
  //               }
  //             } else if (state.status == Status.failure &&
  //                 state.errorMessage != null) {
  //               AppFunctions.showsToast(
  //                 state.errorMessage!,
  //                 ColorManager.red,
  //                 context,
  //               );
  //             }
  //           },
  //           builder: (context, state) {
  //             final isLoggedIn = instance<AppPreferences>()
  //                 .getToken()
  //                 .isNotEmpty;
  //             return _buildActionButton(
  //               icon: IconAssets.logout,
  //               title: isLoggedIn
  //                   ? AppStrings.logout.tr()
  //                   : AppStrings.login.tr(),
  //               color: isLoggedIn ? ColorManager.red : ColorManager.primary,
  //               isLoading: state.status == Status.loading,
  //               onTap: () {
  //                 if (isLoggedIn) {
  //                   context.read<LogoutCubit>().logout();
  //                 } else {
  //                   context.push(AppRouters.login, extra: {"pageIndex": 3});
  //                 }
  //               },
  //             );
  //           },
  //         ),
  //         if (instance<AppPreferences>().getToken().isNotEmpty) ...[
  //           SizedBox(height: 6.h),
  //           BlocConsumer<LogoutCubit, BaseState<BaseModel>>(
  //             listener: (context, state) async {
  //               if (state.status == Status.success) {
  //                 // await instance<AppPreferences>().logout();
  //                 // if (mounted) {
  //                 //   context.go(AppRouters.login);
  //                 // }
  //               } else if (state.status == Status.failure &&
  //                   state.errorMessage != null) {
  //                 // AppFunctions.showsToast(
  //                 //   state.errorMessage!,
  //                 //   ColorManager.red,
  //                 //   context,
  //                 // );
  //               }
  //             },
  //             builder: (context, state) {
  //               return _buildActionButton(
  //                 icon: IconAssets.deleteAccount,
  //                 title: AppStrings.deleteAccount.tr(),
  //                 color: ColorManager.red,
  //                 isLoading: state.status == Status.custom,
  //                 onTap: () {
  //                   AppFunctions.showMyDialog(
  //                     context,
  //                     title: AppStrings.confirmDeleteAccount.tr(),
  //                     onConfirm: () {
  //                       if (instance<AppPreferences>().getToken().isNotEmpty) {
  //                         context.read<LogoutCubit>().logout(isDelete: true);
  //                       } else {
  //                         context.push(AppRouters.login);
  //                       }
  //                     },
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildActionButton({
  //   required String icon,
  //   required String title,
  //   required Color color,
  //   required VoidCallback onTap,
  //   bool isLoading = false,
  // }) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: isLoading ? null : onTap,
  //       borderRadius: BorderRadius.circular(14.r),
  //       child: Container(
  //         width: double.infinity,
  //         padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 12.w),
  //         decoration: BoxDecoration(
  //           color: ColorManager.white.withValues(alpha: 0.7),
  //           borderRadius: BorderRadius.circular(12.r),
  //           border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
  //           boxShadow: [
  //             BoxShadow(
  //               color: color.withValues(alpha: 0.12),
  //               blurRadius: 8.r,
  //               offset: Offset(0, 2.h),
  //               spreadRadius: 0,
  //             ),
  //             BoxShadow(
  //               color: ColorManager.white,
  //               blurRadius: 0,
  //               offset: Offset(0, 0),
  //               spreadRadius: -1,
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             if (isLoading)
  //               SizedBox(
  //                 width: 14.w,
  //                 height: 14.w,
  //                 child: CircularProgressIndicator(
  //                   strokeWidth: 2,
  //                   valueColor: AlwaysStoppedAnimation<Color>(color),
  //                 ),
  //               )
  //             else
  //               SvgPicture.asset(
  //                 icon,
  //                 width: 14.w,
  //                 height: 14.w,
  //                 colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  //               ),
  //             SizedBox(width: 7.w),
  //             Text(
  //               title,
  //               style: getBoldStyle(fontSize: 12.sp, color: color),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
