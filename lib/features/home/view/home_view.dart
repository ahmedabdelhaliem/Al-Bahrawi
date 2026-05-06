import 'dart:async';

import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:al_bahrawi/features/home/cubit/home_cubit.dart';
import 'package:al_bahrawi/features/home/models/statistics_model.dart';
import 'package:al_bahrawi/features/services/cubit/services_cubit.dart';
import 'package:al_bahrawi/features/services/models/services_model.dart';
import 'package:al_bahrawi/features/services/view/services_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll(int itemCount) {
    _timer?.cancel();
    if (itemCount > 1) {
      _timer = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
        if (_pageController.hasClients) {
          int nextPage = _pageController.page!.toInt() + 1;
          if (nextPage >= itemCount) {
            nextPage = 0;
          }
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ServicesCubit()..getServices()),
        BlocProvider(create: (context) => HomeCubit()..getStatistics()),
      ],
      child: BlocListener<ServicesCubit, BaseState<ServicesModel>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            final services = state.data?.data ?? [];
            _startAutoScroll(services.length);
          }
        },
        child: Scaffold(
          backgroundColor: ColorManager.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                _buildStatsSection(),
                _buildServicesSection(context),
                // _buildBottomCTA(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 55.h, bottom: 55.h, left: 20.w, right: 20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.welcomeToAlBahrawi.tr(),
                      style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppStrings.trustedPartner.tr(),
                      style: getRegularStyle(
                        color: ColorManager.white.withValues(alpha: 0.8),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: ColorManager.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.notifications_none, color: ColorManager.white, size: 24.w),
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: ColorManager.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorManager.gold, width: 1.5),
                      ),
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

  Widget _buildStatsSection() {
    return BlocBuilder<HomeCubit, BaseState<StatisticsModel>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return Transform.translate(
            offset: Offset(0, -30.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ShimmerContainerWidget(height: 60.h, width: 60.w, radios: 8.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        final stats = state.data?.data ?? [];
        if (stats.isEmpty) return const SizedBox();

        return Transform.translate(
          offset: Offset(0, -30.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: stats.map((stat) {
                return _buildStatCard(
                  stat.count ?? '',
                  stat.title ?? '',
                  stat.icon ?? '',
                  _getStatColor(stat.id),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Color _getStatColor(int? id) {
    switch (id) {
      case 1:
        return ColorManager.successGreen;
      case 2:
        return ColorManager.azureBlue;
      case 3:
        return ColorManager.gold;
      default:
        return ColorManager.primary;
    }
  }

  Widget _buildStatCard(String value, String label, String iconUrl, Color iconColor) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5), width: 0.5),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CachedNetworkImage(
                imageUrl: iconUrl,
                width: 20.w,
                height: 20.w,
                color: iconColor,
                placeholder: (context, url) => SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Icon(Icons.bar_chart, color: iconColor, size: 20.w),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: getBoldStyle(color: ColorManager.textColor, fontSize: 16.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: getRegularStyle(color: ColorManager.grey, fontSize: 10.sp),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.ourServices.tr(),
                style: getBoldStyle(color: ColorManager.textColor, fontSize: 18.sp),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ServicesView(isPushed: true)),
                  );
                },
                child: Text(
                  AppStrings.viewAll.tr(),
                  style: getBoldStyle(color: ColorManager.primary, fontSize: 14.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          BlocBuilder<ServicesCubit, BaseState<ServicesModel>>(
            builder: (context, state) {
              if (state.status == Status.loading) {
                return _buildShimmerServices();
              }

              final services = state.data?.data ?? [];
              if (services.isEmpty) return const SizedBox();

              return Column(
                children: [
                  ExpandablePageView.builder(
                    controller: _pageController,
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return _buildServiceCard(
                        context,
                        service.id ?? 0,
                        service.name ?? '',
                        service.description ?? '',
                        _getIconForServiceType(service.serviceType?.id),
                        _getIconColorForServiceType(service.serviceType?.id),
                        _getBgColorForServiceType(service.serviceType?.id),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: services.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6.h,
                      dotWidth: 10.w,
                      activeDotColor: ColorManager.primary,
                      dotColor: ColorManager.primary.withValues(alpha: 0.2),
                      expansionFactor: 3,
                      spacing: 8.w,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    int id,
    String title,
    String desc,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return InkWell(
      onTap: () => context.push(AppRouters.serviceDetails, extra: {'serviceId': id}),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.4), width: 0.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12.r)),
              child: Icon(icon, color: iconColor, size: 28.w),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: getBoldStyle(color: ColorManager.textColor, fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              desc,
              style: getRegularStyle(
                color: ColorManager.textColor.withValues(alpha: 0.6),
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForServiceType(int? id) {
    switch (id) {
      case 2: // Tax
        return Icons.percent;
      case 3: // Accounting
        return Icons.account_balance_wallet_outlined;
      case 5: // Company Formation
        return Icons.business_center_outlined;
      default:
        return Icons.miscellaneous_services;
    }
  }

  Color _getBgColorForServiceType(int? id) {
    switch (id) {
      case 2:
        return const Color(0xffE8F5E9);
      case 3:
        return const Color(0xffE3F2FD);
      case 5:
        return const Color(0xffFFF3E0);
      default:
        return const Color(0xffF5F5F5);
    }
  }

  Color _getIconColorForServiceType(int? id) {
    switch (id) {
      case 2:
        return const Color(0xff2E7D32);
      case 3:
        return const Color(0xff1565C0);
      case 5:
        return const Color(0xffEF6C00);
      default:
        return ColorManager.blue;
    }
  }

  Widget _buildShimmerServices() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          height: 180.h,
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.4), width: 0.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerContainerWidget(height: 56.h, width: 56.h, radios: 12.r),
              SizedBox(height: 20.h),
              ShimmerContainerWidget(height: 18.h, width: 140.w),
              SizedBox(height: 10.h),
              ShimmerContainerWidget(height: 12.h, width: 220.w),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: ShimmerContainerWidget(height: 6.h, width: 80.w, radios: 3.r),
        ),
      ],
    );
  }
}
