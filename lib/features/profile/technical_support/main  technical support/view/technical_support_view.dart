import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:al_bahrawi/app/app_functions.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/bottom_nav_bar/models/settings_model.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicalSupportView extends StatefulWidget {
  const TechnicalSupportView({super.key});

  @override
  State<TechnicalSupportView> createState() => _TechnicalSupportViewState();
}

class _TechnicalSupportViewState extends State<TechnicalSupportView> {
  bool _isLoading = true;
  String? _phone;
  String? _whatsapp;
  String? _email;
  String? _supportEmail;

  @override
  void initState() {
    super.initState();
    _fetchSupportSettings();
  }

  Future<void> _fetchSupportSettings() async {
    final response = await DioHelper.getData<SettingsModel>(
      url: EndPoints.settings,
      fromJson: SettingsModel.fromJson,
      isPublic: true,
    );
    response.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      (settings) {
        if (mounted && settings.data != null && settings.data!.isNotEmpty) {
          final s = settings.data!.first;
          setState(() {
            _phone = s.phone;
            _whatsapp = s.whatsapp;
            _email = s.email;
            _supportEmail = s.support;
            _isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _launchWhatsApp() async {
    final number = _whatsapp ?? "+201000000000";
    String cleanedNumber = number.replaceAll('+', '').replaceAll(' ', '');
    final Uri url = Uri.parse("https://wa.me/$cleanedNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        AppFunctions.showsToast("حدث خطأ أثناء محاولة فتح واتساب", ColorManager.red, context);
      }
    }
  }

  Future<void> _launchEmail(String targetEmail) async {
    final Uri url = Uri.parse("mailto:$targetEmail");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        AppFunctions.showsToast("حدث خطأ أثناء محاولة فتح البريد الإلكتروني", ColorManager.red, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _isLoading
                ? _buildShimmerLoading()
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildContactCard(
                          title: "واتساب الدعم الفني",
                          subtitle: _whatsapp ?? "تواصل معنا مباشرة عبر واتساب",
                          icon: Icons.chat_bubble_outline_rounded,
                          iconColor: const Color(0xff25D366),
                          bgColor: const Color(0xff25D366).withValues(alpha: 0.1),
                          onTap: _launchWhatsApp,
                        ),
                        SizedBox(height: 16.h),
                        _buildContactCard(
                          title: "اتصل بنا",
                          subtitle: _phone ?? "+201000000000",
                          icon: Icons.phone_in_talk_rounded,
                          iconColor: ColorManager.blue,
                          bgColor: ColorManager.blue.withValues(alpha: 0.1),
                          onTap: () {
                            if (_phone != null) {
                              AppFunctions.callNumber(context, _phone!);
                            }
                          },
                        ),
                        SizedBox(height: 16.h),
                        _buildContactCard(
                          title: "البريد الإلكتروني للدعم",
                          subtitle: _supportEmail ?? _email ?? "support@elbahrawy.com",
                          icon: Icons.alternate_email_rounded,
                          iconColor: ColorManager.gold,
                          bgColor: ColorManager.gold.withValues(alpha: 0.1),
                          onTap: () {
                            _launchEmail(_supportEmail ?? _email ?? "support@elbahrawy.com");
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: ColorManager.primary.withValues(alpha: 0.05), width: 1),
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
                    style: getBoldStyle(color: ColorManager.blue, fontSize: 15.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(color: ColorManager.greyText, fontSize: 13.sp),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ShimmerContainerWidget(height: 16.h, width: 120.w),
                  SizedBox(height: 8.h),
                  ShimmerContainerWidget(height: 12.h, width: 180.w),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            ShimmerContainerWidget(height: 48.w, width: 48.w, radios: 24.r),
          ],
        ),
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
                AppStrings.technicalSupport.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }
}
