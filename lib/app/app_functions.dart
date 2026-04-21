import 'dart:io';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFunctions {
  static String reverseString(String originalString) {
    List<String> charList = originalString.split('');
    List<String> reversedList = charList.reversed.toList();
    String reversedString = reversedList.join();

    debugPrint('Original String: $originalString');
    debugPrint('Reversed String: $reversedString');

    return reversedString;
  }

  static void showsToast(String text,Color color, BuildContext context,
      {int seconds = 5})
  {
    toastification.show(
      context: context,
      type: color == ColorManager.red ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.minimal,
      // title: Text(color == ColorManager.red ? "Error" :"Success"),
      description: Text(text,style: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyText),),
      alignment: AlignmentDirectional.topEnd,
      autoCloseDuration: Duration(seconds: seconds),
      // icon: Icon(Iconsax.aave_aave),
      borderRadius: BorderRadius.circular(5.r),
      boxShadow: highModeShadow,
      dragToClose: true,
      direction: TextDirection.ltr,
      // applyBlurEffect: true,
    );
    // showToast(text,
    //   context: context,
    //   textStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.white),
    //   backgroundColor: color,
    //   animation: StyledToastAnimation.slideFromTopFade,
    //   reverseAnimation: StyledToastAnimation.slideToTopFade,
    //   position: StyledToastPosition.top,
    //   animDuration: const Duration(seconds: 2),
    //   duration: Duration(seconds: seconds),
    //   curve: Curves.elasticOut,
    //   reverseCurve: Curves.easeInOutCirc,
    //    isIgnoring: false
    // );
  }

  static String prettyTime(String timeString){
    DateTime time = DateTime.parse(timeString);

    String formattedTime = DateFormat('hh:mm:ss a').format(time);

    return formattedTime;
  }

  static String prettyDate(String dateString){
    DateTime date = DateTime.parse(dateString);

    String formattedTime = DateFormat('MM-dd-yyyy').format(date);

    return formattedTime;
  }

  static Future<void> navigateTo(BuildContext context, Widget screen) async {
    await (Platform.isIOS ? Navigator.of(context).push(CupertinoPageRoute(builder: (context) => screen,)) : Navigator.of(context).push(PageTransition(
      child: screen,
      type: PageTransitionType.rightToLeft,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    )));
  }

  static void navigateToAndReplacement(BuildContext context, Widget screen){
    Platform.isIOS ? Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => screen,)) :  Navigator.of(context).pushReplacement(PageTransition(
      child: screen,
      type: PageTransitionType.rightToLeft,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    ));
  }

  static void navigateToAndFinish(BuildContext context, Widget screen){
    Platform.isIOS ? Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => screen,),(route) => false,) :  Navigator.of(context).pushAndRemoveUntil(PageTransition(
      child: screen,
      type: PageTransitionType.fade,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    ),(route) => false,);
  }

  static void popThenNavigateTo(BuildContext context, Widget screen){
    Navigator.pop(context);
    Navigator.of(context).push(PageTransition(
      child: screen,
      type: PageTransitionType.rightToLeft,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    ));
  }

  static String convertToArabic(int number) {
    List<String> arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = '';
    String numberStr = number.toString();

    for (int i = 0; i < numberStr.length; i++) {
      int digit = int.parse(numberStr[i]);
      result += arabicDigits[digit];
    }

    return result;
  }

  static String getYoutubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? url;
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : url;
    }
    return url;
  }

  static void showMyDialog(BuildContext context, {
    Function()? onConfirm,
    required String title,
  })
  {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          contentPadding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
          backgroundColor: ColorManager.white,
          insetPadding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
          children: [
            Text(title,style: getBoldStyle(fontSize: 13.sp, color: ColorManager.black),),
            SizedBox(height: 20.h,),
            Row(
              children: [
                Expanded(
                  child: DefaultButtonWidget(
                    onPressed: () {
                      Navigator.pop(context);
                     if(onConfirm != null) onConfirm.call();
                    },
                    color: ColorManager.primary,
                    textColor: ColorManager.white,
                    text: AppStrings.confirm.tr(),
                    radius: 5.r,
                  ),
                ),
                SizedBox(width: 10.w,),
                Expanded(
                  child: DefaultButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    color: ColorManager.red,
                    textColor: ColorManager.white,
                    text: AppStrings.back.tr(),
                    radius: 5.r,
                  ),
                ),
              ],
            ),
          ],
        );
      },);
  }

  static void copyText({
    required BuildContext context, required bool mounted,
    required String text}) async
  {
    ClipboardData data = ClipboardData(text: text);
    await Clipboard.setData(data);
   if(mounted == true)  showsToast(AppStrings.textCopied.tr(), ColorManager.successGreen, context);
  }

  static void showModalSheet(BuildContext context, {required List<Widget> children,bool isDismissible = true}){
    showModalBottomSheet(
      isScrollControlled: true,
       isDismissible: isDismissible,
       context: context, builder: (BuildContext context) => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
      decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r),
            topRight: Radius.circular(40.r),
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: ColorManager.black.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 15.h,),
          ...children,
        ],
      ),
    ),);
  }

  static Future<void> callNumber(BuildContext context,String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showsToast("Url \"${uri.path}\" is not valid",ColorManager.red,context);
    }
  }
}