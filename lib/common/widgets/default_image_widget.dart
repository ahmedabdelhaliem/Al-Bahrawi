import 'dart:io';

import 'package:al_bahrawi/common/resources/assets_manager.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DefaultImageWidget extends StatefulWidget {
  final String image;
  final double? width;
  final double? height;
  final double? shimmerHeight;
  final void Function()? onTap;
  final double? radius;
  final BoxFit? fit;
  const DefaultImageWidget({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.shimmerHeight,
    this.onTap,
    this.radius,
    this.fit,
  });

  @override
  State<DefaultImageWidget> createState() => _DefaultImageWidgetState();
}

class _DefaultImageWidgetState extends State<DefaultImageWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.radius == null
          ? BorderRadius.zero
          : BorderRadius.circular(widget.radius!),
      child: InkWell(
        onTap: widget.onTap,
        child: widget.image.isEmpty
            ? Lottie.asset(JsonAssets.error)
            : (widget.image.startsWith('http') ||
                  widget.image.startsWith('https'))
            ? CachedNetworkImage(
                imageUrl: widget.image,
                width: widget.width ?? double.infinity,
                height: widget.height,
                fit: widget.fit ?? BoxFit.contain,
                placeholder: (context, url) => ShimmerContainerWidget(
                  height:
                      widget.shimmerHeight ??
                      MediaQuery.sizeOf(context).height * .2,
                ),
                errorWidget: (context, url, error) =>
                    Lottie.asset(JsonAssets.error),
              )
            : Image.file(
                File(widget.image),
                width: widget.width ?? double.infinity,
                height: widget.height,
                fit: widget.fit ?? BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Lottie.asset(JsonAssets.error),
              ),
      ),
    );
  }
}
