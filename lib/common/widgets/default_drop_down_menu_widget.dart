import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_form_field.dart';

class DefaultDropDownMenuWidget<T extends Object> extends StatefulWidget {
  final void Function(T? value) onSelected;
  final void Function(T? item)? onRemove;
  final List<T> items;
  final String hintText;
  final T? selectedValue;
  final bool showItemsWhenFocused;
  final String Function(T? item) optionTitle;
  final String? title;
  final String? prefixSvgIconPath;
  final bool withValidate;
  final String? Function(String? value)? validator;
  final bool isLoading;
  final bool withRemove;
  final bool readOnly;

  const DefaultDropDownMenuWidget({
    super.key,
    required this.onSelected,
    this.onRemove,
    required this.items,
    required this.hintText,
    this.selectedValue,
    this.showItemsWhenFocused = true,
    required this.optionTitle,
    this.title,
    this.prefixSvgIconPath,
    this.withValidate = false,
    this.validator,
    this.isLoading = false,
    this.withRemove = true, this.readOnly = true,
  });

  @override
  State<DefaultDropDownMenuWidget<T>> createState() =>
      _DefaultDropDownMenuWidgetState<T>();
}

class _DefaultDropDownMenuWidgetState<T extends Object>
    extends State<DefaultDropDownMenuWidget<T>> {
  final ScrollController _scrollController = ScrollController();
  T? _selectedValue;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.selectedValue != null) _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return widget.showItemsWhenFocused ? widget.items : [];
        }
        return widget.items
            .where(
              (item) => widget
                  .optionTitle(item)
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()),
            )
            .toList();
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: ColorManager.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: const BorderSide(color: ColorManager.primary),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300.h),
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.fillColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          widget.optionTitle(option),
                          style: getBoldStyle(
                            fontSize: 13.sp,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        _focusNode = focusNode;
        if (_selectedValue != null) {
          controller.text = widget.optionTitle(_selectedValue);
        }
        return _defaultField(controller: controller, focusNode: focusNode);
      },
      onSelected: (value) {
        _selectedValue = value;
        widget.onSelected(_selectedValue);
        _focusNode?.unfocus();
        setState(() {});
      },
    );
  }

  Widget _defaultField({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: DefaultFormField(
        focusNode: focusNode,
        readOnly: widget.readOnly,
        // readOnly: _selectedValue != null || widget.isLoading,
        keyboardType: TextInputType.text,
        onTap: null,
        maxLines: null,
        controller: controller,
        hintText: widget.hintText,
        textStyle: getMediumStyle(
          fontSize: 13.sp,
          color: ColorManager.textColor,
        ),
        titleStyle: getBoldStyle(fontSize: 13.sp, color: ColorManager.black),
        hintStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.grey),
        horizontalPadding: 10.w,
        title: widget.title,
        prefixIconPath: widget.prefixSvgIconPath,
        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
        withValidate: widget.withValidate,
        validator: widget.validator,
        borderRadius: 8.r,
        withRemove: widget.withRemove,
        onRemove: () {
          _selectedValue = null;
          widget.onRemove?.call(_selectedValue);
          controller.clear();
          focusNode.unfocus();
          setState(() {});
        },
        withElevation: true,
      ),
    );
  }
}
