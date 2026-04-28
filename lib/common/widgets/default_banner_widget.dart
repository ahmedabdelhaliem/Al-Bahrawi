import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_image_widget.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_manager.dart';

class DefaultBannerWidget<T> extends StatefulWidget {
  final List<T> images;
  final String Function(T image) imageUrl;
  final void Function(T image, int index)? imageOnTap;
  final bool enlargeCenterPage;
  final double aspectRatio;
  final double viewportFraction;
  final double enlargeFactor;
  final bool isLoading;
  final bool showIndicators;
  final bool indicatorsAsNumbers;
  final BoxFit fit;
  final Color? indicatorBackgroundColor;
  final double? indicatorBottomHeight;

  const DefaultBannerWidget(
      {super.key,
      required this.images,
      this.imageOnTap,
      required this.imageUrl,
      this.enlargeCenterPage = true,
      this.aspectRatio = 16 / 9,
      this.viewportFraction = 1,
      this.isLoading = false,
      this.enlargeFactor = .3,
      this.showIndicators = true,
        this.fit = BoxFit.cover,
        this.indicatorsAsNumbers = false,
        this.indicatorBackgroundColor, this.indicatorBottomHeight,
      });

  @override
  State<DefaultBannerWidget<T>> createState() => _DefaultBannerWidgetState<T>();
}

class _DefaultBannerWidgetState<T> extends State<DefaultBannerWidget<T>> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || widget.images.isEmpty) {
      return AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: ShimmerContainerWidget(height: 200.h));
    }
    if (widget.images.length == 1) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: DefaultImageWidget(
            fit: widget.fit,
            image: widget.imageUrl.call(widget.images.first),
            onTap: widget.imageOnTap == null? null : () {
              widget.imageOnTap!.call(widget.images.first, _index);
            },
            radius: 10.r,
          ),
        ),
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        carousel.CarouselSlider(
          options: carousel.CarouselOptions(
            initialPage: 0,
            enableInfiniteScroll: true,
            viewportFraction: widget.viewportFraction,
            enlargeCenterPage: true,
            enlargeFactor: widget.enlargeFactor,
            aspectRatio: widget.aspectRatio,
            pageSnapping: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayCurve: Curves.linear,
            autoPlayAnimationDuration: const Duration(milliseconds: 300),
            autoPlay: widget.images.length != 1,
            onPageChanged: (index, _) {
              setState(() {
                _index = index;
              });
            },
          ),
          items: widget.images.map(
            (image) {
              return DefaultImageWidget(
                fit: widget.fit,
                image: widget.imageUrl.call(image),
                onTap: widget.imageOnTap == null? null : () {
                  widget.imageOnTap!.call(image, _index);
                },
                radius: 10.r,
              );
            },
          ).toList(),
        ),
        if (widget.showIndicators) _indicator(),
      ],
    );
  }

  _indicator() {
    return Positioned(
      bottom: widget.indicatorBottomHeight??20.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        margin: EdgeInsets.only(bottom: 5.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: widget.indicatorBackgroundColor ?? ColorManager.greyBorder),
        child: widget.indicatorsAsNumbers ? Text(
          "${_index+1}/${widget.images.length}",style: getBoldStyle(color: Colors.white,fontSize: 12.sp),) : Row(
          spacing: 5.w,
          mainAxisSize: MainAxisSize.min,
          children: widget.images.asMap().entries.map((entry) {
            return GestureDetector(
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _index == entry.key
                        ? ColorManager.primary
                        : ColorManager.white),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
