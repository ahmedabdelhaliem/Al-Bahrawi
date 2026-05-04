import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:al_bahrawi/features/services/cubit/services_cubit.dart';
import 'package:al_bahrawi/features/services/models/services_model.dart';

class ServicesView extends StatefulWidget {
  final bool isPushed;
  const ServicesView({super.key, this.isPushed = false});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  int _selectedFilter = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = [
    AppStrings.all,
    AppStrings.tax,
    AppStrings.accounting,
    AppStrings.companyFormation,
  ];

  final List<int?> _filterIds = [
    0, // All
    2, // Tax Planning
    3, // Accounting
    5, // Company Formation
  ];

  @override
  void initState() {
    super.initState();
    // Initial fetch
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesCubit()..getServices(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: ColorManager.white,
          body: Column(
            children: [
              _buildHeader(),
              _buildSearchAndFilters(context),
              Expanded(child: _buildServicesList()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 55.h, bottom: 65.h, left: 20.w, right: 20.w),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (widget.isPushed) ...[
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios, color: ColorManager.white),
                            padding: EdgeInsets.zero,
                          ),
                          SizedBox(width: 10.w),
                        ],
                        Text(
                          AppStrings.ourServices.tr(),
                          style: getBoldStyle(color: ColorManager.white, fontSize: 26.sp),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      AppStrings.servicesSubtitle.tr(),
                      style: getRegularStyle(
                        color: ColorManager.white.withValues(alpha: 0.9),
                        fontSize: 13.sp,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -30.h),
      child: Column(
        children: [
          // White Card containing the Search field
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Grey Search Field
                Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textAlign: TextAlign.right,
                    style: getRegularStyle(color: ColorManager.blue, fontSize: 14.sp),
                    onChanged: (value) {
                      context.read<ServicesCubit>().getServices(
                        serviceTypeId: _filterIds[_selectedFilter],
                        search: value,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: AppStrings.searchForService.tr(),
                      hintStyle: getRegularStyle(
                        color: ColorManager.grey.withValues(alpha: 0.6),
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Icon(Icons.search, color: ColorManager.grey, size: 22.w),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true, // For RTL feel
                  child: Row(
                    children: List.generate(_filters.length, (index) {
                      bool isSelected = _selectedFilter == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedFilter = index);
                          context.read<ServicesCubit>().getServices(
                            serviceTypeId: _filterIds[index],
                            search: _searchController.text,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? ColorManager.blue : ColorManager.fillColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            _filters[index].tr(),
                            style: getBoldStyle(
                              color: isSelected ? ColorManager.white : ColorManager.grey,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return BlocBuilder<ServicesCubit, BaseState<ServicesModel>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildShimmerList();
        }

        if (state.status == Status.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? AppStrings.unKnownError.tr()),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<ServicesCubit>().getServices(
                          serviceTypeId: _filterIds[_selectedFilter],
                          search: _searchController.text,
                        );
                  },
                  child: Text(AppStrings.tryAgain.tr()),
                ),
              ],
            ),
          );
        }

        final services = state.data?.data ?? [];

        if (services.isEmpty) {
          return Center(child: Text(AppStrings.noData.tr()));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          physics: const BouncingScrollPhysics(),
          itemCount: services.length + 2, // Header text + Spacing at bottom
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppStrings.availableService.tr(),
                    style: getRegularStyle(color: ColorManager.grey, fontSize: 12.sp),
                  ),
                ),
              );
            }

            if (index == services.length + 1) {
              return SizedBox(height: 80.h);
            }

            final service = services[index - 1];
            return _buildServiceCard(
              context,
              service.id ?? 0,
              service.name ?? '',
              service.serviceType?.name ?? '',
              service.description ?? '',
              _getIconForServiceType(service.serviceType?.id),
              _getBgColorForServiceType(service.serviceType?.id),
              _getIconColorForServiceType(service.serviceType?.id),
            );
          },
        );
      },
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

  Widget _buildServiceCard(
    BuildContext context,
    int id,
    String title,
    String category,
    String desc,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return InkWell(
      onTap: () => context.push(AppRouters.serviceDetails, extra: {'serviceId': id}),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.arrow_back_ios, color: ColorManager.grey, size: 12.w),
            const Spacer(),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    category,
                    style: getRegularStyle(
                      color: ColorManager.grey.withValues(alpha: 0.6),
                      fontSize: 9.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: getBoldStyle(color: ColorManager.blue, fontSize: 14.sp),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    desc,
                    style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12.r)),
              child: Icon(icon, color: iconColor, size: 24.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            children: [
              ShimmerContainerWidget(height: 12.h, width: 12.w, radios: 4.r),
              const Spacer(),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerContainerWidget(height: 10.h, width: 60.w),
                    SizedBox(height: 8.h),
                    ShimmerContainerWidget(height: 15.h, width: 150.w),
                    SizedBox(height: 8.h),
                    ShimmerContainerWidget(height: 10.h, width: 200.w),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              ShimmerContainerWidget(height: 44.h, width: 44.w, radios: 12.r),
            ],
          ),
        );
      },
    );
  }
}
