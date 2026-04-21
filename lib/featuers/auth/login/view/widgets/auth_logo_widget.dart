import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/assets_manager.dart';

class AuthLogoWidget extends StatefulWidget {
  final double? size;
  const AuthLogoWidget({super.key, this.size});

  @override
  State<AuthLogoWidget> createState() => _AuthLogoWidgetState();
}

class _AuthLogoWidgetState extends State<AuthLogoWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ImageAssets.logo,
        height: widget.size ?? 150.w,
        width: widget.size ?? 150.w,
        fit: BoxFit.contain,
      ),
    );
  }
}
