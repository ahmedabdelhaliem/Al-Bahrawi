import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/features/services/view/services_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Transform.translate(
      offset: Offset(0, -30.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            _buildStatCard(
              "5K+",
              AppStrings.completedConsultations.tr(),
              Icons.verified,
              ColorManager.successGreen,
            ),
            SizedBox(width: 10.w),
            _buildStatCard(
              "2K+",
              AppStrings.satisfiedClients.tr(),
              Icons.people,
              ColorManager.azureBlue,
            ),
            SizedBox(width: 10.w),
            _buildStatCard(
              "15+",
              AppStrings.yearsOfExperience.tr(),
              Icons.military_tech,
              ColorManager.gold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
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
              child: Icon(icon, color: iconColor, size: 20.w),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: getBoldStyle(color: ColorManager.textColor, fontSize: 16.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: getRegularStyle(color: ColorManager.grey, fontSize: 10.sp),
              textAlign: TextAlign.center,
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
          ExpandablePageView(
            controller: _pageController,
            children: [
              _buildServiceCard(
                AppStrings.taxConsultation.tr(),
                AppStrings.taxConsultationDesc.tr(),
                Icons.account_balance,
                const Color(0xff2E7D32),
                const Color(0xffE8F5E9),
              ),
              _buildServiceCard(
                AppStrings.accounting.tr(),
                AppStrings.accountingDesc.tr(),
                Icons.grid_view_rounded,
                const Color(0xff3F51B5),
                const Color(0xffE8EAF6),
              ),
              _buildServiceCard(
                AppStrings.companyFormation.tr(),
                AppStrings.companyFormationDesc.tr(),
                Icons.business,
                const Color(0xffE65100),
                const Color(0xffFFF3E0),
              ),
              _buildServiceCard(
                AppStrings.auditing.tr(),
                AppStrings.auditingDesc.tr(),
                Icons.fact_check_rounded,
                const Color(0xff00695C),
                const Color(0xffE0F2F1),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SmoothPageIndicator(
            controller: _pageController,
            count: 4,
            effect: ExpandingDotsEffect(
              dotHeight: 6.h,
              dotWidth: 10.w,
              activeDotColor: ColorManager.primary,
              dotColor: ColorManager.primary.withValues(alpha: 0.2),
              expansionFactor: 3,
              spacing: 8.w,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    String desc,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
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
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.8)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.haveFinancialInquiry.tr(),
            style: getBoldStyle(color: ColorManager.white, fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.contactOurConsultants.tr(),
            style: getRegularStyle(
              color: ColorManager.white.withValues(alpha: 0.8),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          DefaultButtonWidget(
            onPressed: () {},
            text: AppStrings.requestConsultationBtn.tr(),
            color: ColorManager.white,
            textColor: ColorManager.blue,
            radius: 12.r,
            isIcon: true,
            textFirst: true,
            iconBuilder: Icon(Icons.arrow_forward, color: ColorManager.gold, size: 20.sp),
          ),
        ],
      ),
    );
  }
}
