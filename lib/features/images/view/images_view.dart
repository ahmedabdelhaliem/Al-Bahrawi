import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesView extends StatefulWidget {
  final List<String> images;
  final int initialPage;
  const ImagesView({super.key, required this.images, required this.initialPage});

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  PageController? pageController;
  int currentIndex = 0;
  void Function(void Function())? _indexSetState;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialPage;
    pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          PhotoViewGallery.builder(
            // scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: widget.images[index].startsWith('http') ? NetworkImage(widget.images[index]) : FileImage(File(widget.images[index])),
                // initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.images[index].hashCode),
              );
            },
            itemCount: widget.images.length,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 50.0.w,
                height: 50.0.w,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  value: event == null || event.expectedTotalBytes == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!.toDouble(),
                ),
              ),
            ),
            // backgroundDecoration: widget.backgroundDecoration,
            // pageController: widget.pageController,
pageController: pageController,
            onPageChanged: (index) {
              currentIndex = index;
              _indexSetState!((){});
            },
          ),
          // CarouselSlider(
          //   items: widget.images.map((e) => InteractiveViewer(
          //     trackpadScrollCausesScale: true,
          //       child: Image.network(e)),).toList(),
          //   // '${Provider.of<SplashController>(context,listen: false).baseUrls?.productImageUrl}''/$e'),).toList(),
          //   options: CarouselOptions(
          //     height: MediaQuery.of(context).size.height,
          //     // autoPlay: true,
          //     initialPage: widget.initialPage,
          //     enableInfiniteScroll: true,
          //     viewportFraction: 1,
          //     // enlargeCenterPage: true,
          //     enlargeFactor: 0.3,
          //     pageSnapping: true,
          //     autoPlayInterval: const Duration(seconds: 3),
          //     autoPlayCurve: Curves.linear,
          //     autoPlayAnimationDuration: const Duration(milliseconds: 500),
          //     onPageChanged: (index, reason) {
          //       currentIndex = index;
          //       _indexSetState!((){});
          //     },
          //   ),
          // ),
          Positioned(
            top: MediaQuery.sizeOf(context).height*.1,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
                decoration: BoxDecoration(
                  color: ColorManager.greyBorder,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: StatefulBuilder(builder: (context, setState) {
                  _indexSetState = setState;
                  return Text(
                    "${currentIndex+1}/${widget.images.length}",style: TextStyle(color: Colors.black,fontSize: 12.sp),);
                },)),
          ),
        ],
      ),
    );
  }
}
