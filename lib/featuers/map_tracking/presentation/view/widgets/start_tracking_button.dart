import 'package:flutter/material.dart';
import 'package:base_project/common/resources/color_manager.dart';

class StartTrackingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StartTrackingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'ابدأ التتبع',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
