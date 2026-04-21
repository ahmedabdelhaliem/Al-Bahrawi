import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_app_bar.dart';
import 'package:base_project/common/widgets/default_banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/featuers/home/cubit/banners_cubit.dart';
import 'package:base_project/featuers/home/model/banners_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: DefaultAppBar(
            withLeading: false,
            titleWidget: _appBar(),
            elevation: 2,
            height: MediaQuery.sizeOf(context).height*.09,
          ),
          body: ListView(
            padding: EdgeInsets.only(bottom: 4.h,top: 4.h),
            physics: const ClampingScrollPhysics(),
            children: [
              _banners(),
              SizedBox(height: 8.h,),
            ],
          ),
        );
      }
    );
  }

  _appBar(){
    return Row(
      children: [
        _logo(),
        Spacer(),
        _notificationButton(),
      ],
    );
  }

  _logo(){
    final userImage = instance<AppPreferences>().getUserImage();

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        PositionedDirectional(
          start: 40.w,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              gradient: LinearGradient(
                colors: ColorManager.gradientPrimary,
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primary.withValues(alpha: 0.2),
                  blurRadius: 2.r,
                  offset: Offset(0, 1.h),
                ),
              ],
            ),
            child: Text(
             "${AppStrings.hello.tr()} ... ${instance<AppPreferences>().getUserName()}",
              style: getBoldStyle(
                fontSize: 12.sp,
                color: ColorManager.white,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorManager.primary,
              width: 3.5.w,
            ),
          ),
          child: CircleAvatar(
            radius: 25.r,
            backgroundColor: ColorManager.white,
            backgroundImage: userImage == null
                ? null
                : NetworkImage(userImage) as ImageProvider,
            child: userImage == null
                ? Image.asset(
              ImageAssets.logo,
              width: 30.w,
              height: 30.w,
            )
                : null,
          ),
        ),
      ],
    );
  }

  _notificationButton(){
    return InkWell(
      onTap: () {
        context.push(AppRouters.notifications);
      },
      borderRadius: BorderRadius.circular(50.r),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ColorManager.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorManager.greyBorder,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.04),
                  blurRadius: 6.r,
                  offset: Offset(0, 1.5.h),
                ),
              ],
            ),
            child: SvgPicture.asset(
              IconAssets.notification,
              width: 16.w,
              height: 16.w,
              colorFilter: ColorFilter.mode(
                ColorManager.black,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: ColorManager.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorManager.white,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.red.withValues(alpha: 0.4),
                    blurRadius: 3.r,
                    spreadRadius: 0.3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _banners() {
    return BlocProvider(
      create: (context) =>
      BannersCubit()
        ..getBanners(),
      child: BlocBuilder<BannersCubit, BaseState<BannersModel>>(
        builder: (context, state) {
          return DefaultBannerWidget<BannerModel>(
            images: state.data?.data ?? [],
            imageUrl: (image) => image.banner ?? '',
            isLoading: state.status == Status.loading,
            viewportFraction: .9,
            enlargeFactor: .2,
            showIndicators: false,
            aspectRatio: 3,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}
