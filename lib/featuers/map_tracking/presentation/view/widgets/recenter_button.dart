import 'package:flutter/material.dart';
import 'package:base_project/common/resources/color_manager.dart';

class RecenterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RecenterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: ColorManager.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
