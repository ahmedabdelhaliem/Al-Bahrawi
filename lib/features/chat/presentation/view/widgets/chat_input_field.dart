import 'dart:io';
import 'dart:ui';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputField extends StatefulWidget {
  final Function(String?, String?) onSend;

  const ChatInputField({super.key, required this.onSend});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateContentState);
  }

  void _updateContentState() {
    setState(() {
      _hasContent = _controller.text.trim().isNotEmpty || _selectedImagePath != null;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
      _updateContentState();
    }
  }

  void _handleSend() {
    if (_hasContent) {
      widget.onSend(
        _controller.text.trim().isEmpty ? null : _controller.text.trim(),
        _selectedImagePath,
      );
      _controller.clear();
      setState(() {
        _selectedImagePath = null;
      });
      _updateContentState();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateContentState);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Preview (Sleek overlay)
            if (_selectedImagePath != null)
              _buildImagePreview(),
              
            ClipRRect(
              borderRadius: BorderRadius.circular(32.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: ColorManager.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Camera/Gallery Button
                      _buildActionButton(
                        icon: Icons.add_rounded,
                        onTap: _pickImage,
                        color: ColorManager.bg,
                        iconColor: ColorManager.primary,
                      ),
                      
                      SizedBox(width: 8.w),
                      
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: TextStyle(fontSize: 14.sp, color: ColorManager.blackText),
                          decoration: InputDecoration(
                            hintText: AppStrings.messageHint.tr(),
                            hintStyle: TextStyle(color: ColorManager.greyTextColor.withValues(alpha: 0.7), fontSize: 14.sp),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                          ),
                          maxLines: 4,
                          minLines: 1,
                        ),
                      ),
                      
                      SizedBox(width: 8.w),
                      
                      // Send Button
                      _buildActionButton(
                        icon: Icons.send_rounded,
                        onTap: _handleSend,
                        color: _hasContent ? ColorManager.gold : ColorManager.greyTextColor.withValues(alpha: 0.1),
                        iconColor: _hasContent ? Colors.white : ColorManager.greyTextColor.withValues(alpha: 0.4),
                        isActive: _hasContent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
    bool isActive = true,
  }) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              File(_selectedImagePath!),
              fit: BoxFit.cover,
              height: 120.h,
              width: 120.h,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedImagePath = null);
                _updateContentState();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: Icon(Icons.close, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
  }

