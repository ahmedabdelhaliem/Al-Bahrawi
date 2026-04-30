import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildSection(
                          "مرحبا بكم في البحراوي",
                          "تعتبر شركة ال بحراوي من الشركات الرائدة في تقديم الاستشارات المالية والضريبية وتأسيس الشركات. نحن نفخر بتقديم حلول مبتكرة وشاملة تلبي تطلعات عملائنا وتساهم في نمو أعمالهم واستقرارها المالي.",
                        ),
                        const Divider(height: 1, color: Color(0xffF3F4F6)),
                        SizedBox(height: 24.h),
                        _buildSection(
                          "رؤيتنا",
                          "أن نكون الشريك المالي الأول والموثوق لكافة الشركات والمؤسسات في المنطقة، من خلال تقديم خدمات مهنية تتسم بالشفافية والابتكار، والمساهمة الفعالة في بناء مستقبل مالي مستدام لعملائنا.",
                        ),
                        const Divider(height: 1, color: Color(0xffF3F4F6)),
                        SizedBox(height: 24.h),
                        _buildSection(
                          "رسالتنا",
                          "الالتزام بتقديم أعلى معايير الجودة في الخدمات المحاسبية والضريبية، وتوفير بيئة عمل محفزة لفريقنا لضمان تقديم أفضل الاستشارات التي تساعد عملائنا على اتخاذ قرارات مالية حكيمة ومدروسة.",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30.h,
            left: 24.w,
            child: GestureDetector(
              onTap: () {
                // TODO: Implement WhatsApp redirection
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xff25D366),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff25D366).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.chat_bubble_rounded, color: ColorManager.white, size: 28.w),
              ),
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
                AppStrings.aboutUs.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: getBoldStyle(color: ColorManager.blue, fontSize: 18.sp),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: getRegularStyle(color: ColorManager.greyText, fontSize: 14.sp),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
