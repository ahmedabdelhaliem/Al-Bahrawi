import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/assets_manager.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/language_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/common/widgets/default_radio_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = _appPreferences.getAppLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  // Logo
                  Center(
                    child: Image.asset(
                      ImageAssets.logoSplash,
                      width: 150.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  // Bottom sheet style card
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            AppStrings.chooseLanguage.tr(),
                            style: getBoldStyle(
                              fontSize: 18.sp,
                              color: ColorManager.textColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Arabic Option
                        DefaultRadioButton(
                          selected: _selectedLanguage == LanguageType.ARABIC.getValue(),
                          title: AppStrings.arabic.tr(),
                          onTap: () {
                            setState(() {
                              _selectedLanguage = LanguageType.ARABIC.getValue();
                            });
                          },
                          containerBorderColor: _selectedLanguage == LanguageType.ARABIC.getValue()
                              ? ColorManager.primary
                              : ColorManager.greyBorder,
                          titleStyle: getMediumStyle(
                            fontSize: 16.sp,
                            color: ColorManager.textColor,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // English Option
                        DefaultRadioButton(
                          selected: _selectedLanguage == LanguageType.ENGLISH.getValue(),
                          title: AppStrings.english.tr(),
                          onTap: () {
                            setState(() {
                              _selectedLanguage = LanguageType.ENGLISH.getValue();
                            });
                          },
                          containerBorderColor: _selectedLanguage == LanguageType.ENGLISH.getValue()
                              ? ColorManager.primary
                              : ColorManager.greyBorder,
                          titleStyle: getMediumStyle(
                            fontSize: 16.sp,
                            color: ColorManager.textColor,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Next Button
                        DefaultButtonWidget(
                          onPressed: () {
                            _changeLanguage();
                          },
                          text: AppStrings.next.tr(),
                          textColor: ColorManager.white,
                          radius: 12.r,
                          verticalPadding: 14.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeLanguage() async {
    if (_selectedLanguage == LanguageType.ENGLISH.getValue()) {
      await context.setLocale(ENGLISH_LOCALE);
    } else {
      await context.setLocale(ARABIC_LOCALE);
    }
    
    // Save to prefs (manually update the key as changeAppLanguage flips it)
    // Actually better to add a setLanguage method to AppPreferences
    // For now, I'll assume changeAppLanguage is what we have or I'll use SharedPreferences directly if needed.
    // Let's use getAppLanguage to see if we need to flip.
    if (_appPreferences.getAppLanguage() != _selectedLanguage) {
        await _appPreferences.changeAppLanguage();
    }
    
    if (mounted) {
      context.go(AppRouters.onBoarding);
    }
  }
}
