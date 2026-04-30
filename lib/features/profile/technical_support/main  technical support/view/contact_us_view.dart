import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  _buildFormSection(),
                  SizedBox(height: 50.h),
                ],
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
                AppStrings.contactUs.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
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
          Text(
            "مرحباً بك",
            style: getBoldStyle(color: ColorManager.blue, fontSize: 24.sp),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 12.h),
          Text(
            "نسعد بتواصلك معنا، يرجى ملء النموذج أدناه وسنعاود الاتصال بك في أقرب وقت ممكن.",
            style: getRegularStyle(color: ColorManager.greyText, fontSize: 14.sp),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 24.h),
          const Divider(height: 1, color: Color(0xffF3F4F6)),
          SizedBox(height: 24.h),
          _buildLabel("سبب المشكلة"),
          _buildDropdownField("إختر سبب التواصل"),
          SizedBox(height: 20.h),
          _buildLabel("رسالة"),
          _buildTextField("اكتب رسالتك هنا...", maxLines: 5),
          SizedBox(height: 32.h),
          DefaultButtonWidget(
            text: "ارسال",
            onPressed: () {
              // TODO: Implement send logic
              Navigator.pop(context);
            },
            color: ColorManager.primary,
            textColor: ColorManager.white,
            height: 55.h,
            radius: 12.r,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: getBoldStyle(color: const Color(0xff374151), fontSize: 14.sp),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: getRegularStyle(color: ColorManager.grey.withValues(alpha: 0.4), fontSize: 14.sp),
        fillColor: const Color(0xffF9FAFB),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorManager.greyBorder.withValues(alpha: 0.2), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorManager.greyBorder.withValues(alpha: 0.1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: ColorManager.blue, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.1), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: getRegularStyle(color: ColorManager.grey.withValues(alpha: 0.4), fontSize: 14.sp),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: ColorManager.grey),
          items: [],
          onChanged: (val) {},
        ),
      ),
    );
  }
}
