import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:al_bahrawi/common/resources/assets_manager.dart';

class DefaultLoadingWidget extends StatefulWidget {
  final bool applyTopHeight;
  const DefaultLoadingWidget({super.key, this.applyTopHeight = false});

  @override
  State<DefaultLoadingWidget> createState() => _DefaultLoadingWidgetState();
}

class _DefaultLoadingWidgetState extends State<DefaultLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.applyTopHeight ? MediaQuery.sizeOf(context).height*.1 : 0),
      child: Center(
        child: SizedBox(
          height: 150.h,
          child: Lottie.asset(JsonAssets.loading),
        ),
      ),
    );
  }
}
