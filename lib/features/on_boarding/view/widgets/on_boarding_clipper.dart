import 'package:flutter/material.dart';

class OnBoardingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    
    path.quadraticBezierTo(
      size.width * 0.25, 
      size.height, 
      size.width * 0.5, 
      size.height - 50
    );
    
    path.quadraticBezierTo(
      size.width * 0.75, 
      size.height - 100, 
      size.width, 
      size.height
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
