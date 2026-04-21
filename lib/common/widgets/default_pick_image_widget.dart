import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class DefaultPickImageWidget extends StatefulWidget {
  final int count;
  final void Function(List<File>)? onImagesPicked;

  const DefaultPickImageWidget({
    super.key,
    required this.count,
    this.onImagesPicked,
  });

  @override
  State<DefaultPickImageWidget> createState() => _DefaultPickImageWidgetState();
}

class _DefaultPickImageWidgetState extends State<DefaultPickImageWidget> {
  late List<XFile?> _pickedImages;

  @override
  void initState() {
    super.initState();
    _pickedImages = List<XFile?>.filled(widget.count, null);
  }

  Future<void> _pickImage(int index) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImages[index] = image;
      });
      if (widget.onImagesPicked != null) {
        final List<File> validImages = _pickedImages
            .where((element) => element != null)
            .map((e) => File(e!.path))
            .toList();
        widget.onImagesPicked!(validImages);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate((widget.count / 2).ceil(), (rowIndex) {
        final firstIndex = rowIndex * 2;
        final secondIndex = firstIndex + 1;

        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              Expanded(child: _buildItem(firstIndex)),
              SizedBox(width: 10.w),
              if (secondIndex < widget.count)
                Expanded(child: _buildItem(secondIndex)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildItem(int index) {
    return InkWell(
      onTap: () => _pickImage(index),
      borderRadius: BorderRadius.circular(10.r),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: const [10, 5],
          radius: Radius.circular(10.r),
          color: ColorManager.primary,
        ),
        child: SizedBox(
          height: 100.h,
          child: _pickedImages[index] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    File(_pickedImages[index]!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(IconAssets.addImage, height: 24.h),
                      SizedBox(height: 8.h),
                      Text(
                        AppStrings.pleaseAddImage.tr(),
                        textAlign: TextAlign.center,
                        style: getMediumStyle(
                          color: ColorManager.primary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
