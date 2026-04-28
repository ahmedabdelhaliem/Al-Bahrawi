import 'package:al_bahrawi/common/resources/assets_manager.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/features/on_boarding/model/on_boarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingWidget extends StatefulWidget {
  final OnBoardingItemModel item;
  const OnBoardingWidget({super.key, required this.item});

  @override
  State<OnBoardingWidget> createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.item.image ?? '';

    Widget imageWidget;
    if (imagePath.isEmpty) {
      imageWidget = const SizedBox.shrink();
    } else if (imagePath.startsWith('http')) {
      imageWidget = Image.network(
        imagePath,
        fit: BoxFit.contain,
      );
    } else {
      imageWidget = Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          ImageAssets.logo,
          fit: BoxFit.contain,
        ),
      );
    }

    return ClipPath(
      clipper: BottomArcClipper(),
      child: SizedBox(
        width: double.infinity,
        height: 0.6.sh,
        child: imageWidget,
      ),
    );
  }
}

class BottomArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
