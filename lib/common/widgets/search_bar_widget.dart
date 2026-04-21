import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_form_field.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String value)? onChanged;
  const SearchBarWidget({super.key, this.onChanged});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return DefaultFormField(
      controller: _searchController,
      withElevation: true,
      hintText: AppStrings.searchForCar.tr(),
      prefixIconPath: IconAssets.search,
      suffixIconPath: IconAssets.logo,
      borderRadius: 12.r,
      hintStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
      onChanged: (value){
      if(widget.onChanged != null)  {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 800), () =>  widget.onChanged!(value));
        }
      },
    );
  }
}
