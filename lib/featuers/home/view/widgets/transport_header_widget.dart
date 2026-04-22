import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TransportHeaderWidget extends StatelessWidget {
  final double height;
  final String? title;
  final bool showBackButton;
  
  const TransportHeaderWidget({
    super.key, 
    required this.height, 
    this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final userName = instance<AppPreferences>().getUserName();
    final userImage = instance<AppPreferences>().getUserImage();

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: ColorManager.primary,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1A237E)],
        ),
      ),
      child: Stack(
        children: [
          // Subtle Mesh Pattern Ornament
          Positioned(
            top: -50.h,
            right: -30.w,
            child: Container(
              width: 150.r,
              height: 150.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -20.h,
            left: 20.w,
            child: Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 10.r),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20.w, MediaQuery.of(context).padding.top + 10.h, 20.w, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Side 1: Bus Image or Notification (If title is null/empty)
                if (title != null)
                  Image.asset(
                    ImageAssets.bus,
                    width: MediaQuery.of(context).size.width / 2.5,
                    fit: BoxFit.contain,
                  )
                else
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: SvgPicture.asset(
                      IconAssets.notification,
                      width: 24.w,
                      height: 24.w,
                      colorFilter: const ColorFilter.mode(ColorManager.white, BlendMode.srcIn),
                    ),
                  ),

                // Side 2: Back Button or User/Title
                if (showBackButton)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 18.r, color: ColorManager.white),
                    ),
                  )
                else if (title != null && title!.isNotEmpty)
                  Flexible(
                    child: Text(
                      title!,
                      style: getBoldStyle(color: ColorManager.white, fontSize: 18.sp),
                    ),
                  )
                else if (title == null)
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppStrings.welcome.tr(),
                                style: getRegularStyle(color: Colors.white70, fontSize: 12.sp),
                              ),
                              Text(
                                userName ?? "محمد",
                                style: getBoldStyle(color: ColorManager.white, fontSize: 18.sp),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Container(
                          padding: EdgeInsets.all(3.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5.w,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 22.r,
                            backgroundColor: ColorManager.grey,
                            backgroundImage: userImage != null && userImage.isNotEmpty
                                ? NetworkImage(userImage) as ImageProvider
                                : const AssetImage(ImageAssets.profile),
                            child: userImage == null
                                ? Icon(Icons.person, color: ColorManager.white, size: 24.r)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransportHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String? title;
  final bool showBackButton;

  TransportHeaderDelegate({this.title, this.showBackButton = false});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return TransportHeaderWidget(
      height: maxExtent, 
      title: title,
      showBackButton: showBackButton,
    );
  }

  @override
  double get maxExtent => 130.h + ScreenUtil().statusBarHeight;

  @override
  double get minExtent => 130.h + ScreenUtil().statusBarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
