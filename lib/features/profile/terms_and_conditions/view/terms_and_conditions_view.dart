import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(16.r),
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
                    _buildTermSection(
                      "1. مقدمة",
                      "أهلاً بك في تطبيق ال بحراوي. باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بالشروط والأحكام التالية. يرجى قراءتها بعناية قبل البدء في استخدام الخدمات.",
                    ),
                    _buildTermSection(
                      "2. الخدمات المقدمة",
                      "يوفر التطبيق خدمات استشارية مالية وضريبية، وتأسيس الشركات، والمراجعة المحاسبية. هذه الخدمات تهدف لمساعدة الشركات والأفراد في تحسين أدائهم المالي.",
                    ),
                    _buildTermSection(
                      "3. الخصوصية وحماية البيانات",
                      "نحن نلتزم بحماية بياناتك الشخصية والمالية. يتم استخدام البيانات المرفوعة فقط لأغراض تقديم الاستشارة المطلوبة ولا يتم مشاركتها مع أي طرف ثالث دون موافقتك.",
                    ),
                    _buildTermSection(
                      "4. التزامات المستخدم",
                      "يجب على المستخدم تقديم معلومات دقيقة وصحيحة. أي تضليل في البيانات قد يؤدي إلى استشارات غير دقيقة، ويتحمل المستخدم مسؤولية ذلك.",
                    ),
                    _buildTermSection(
                      "5. حقوق الملكية",
                      "جميع المحتويات والعلامات التجارية الموجودة في التطبيق هي ملك لشركة ال بحراوي، ولا يجوز إعادة استخدامها دون إذن خطي.",
                    ),
                    _buildTermSection(
                      "6. التعديلات",
                      "نحتفظ بالحق في تعديل هذه الشروط والأحكام في أي وقت. سيتم إخطار المستخدمين بأي تغييرات جوهرية عبر التطبيق.",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: getBoldStyle(color: ColorManager.blue, fontSize: 16.sp),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: getRegularStyle(color: ColorManager.greyText, fontSize: 13.sp),
            textAlign: TextAlign.right,
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
                AppStrings.termsAndConditions.tr(),
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
