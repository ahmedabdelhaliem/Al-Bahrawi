import 'dart:io';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/features/services/cubit/consultation_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RequestConsultationView extends StatefulWidget {
  final int serviceId;
  const RequestConsultationView({super.key, required this.serviceId});

  @override
  State<RequestConsultationView> createState() => _RequestConsultationViewState();
}

class _RequestConsultationViewState extends State<RequestConsultationView> {
  bool isChat = true;
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsultationCubit(),
      child: BlocListener<ConsultationCubit, BaseState<dynamic>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            context.pushReplacement(AppRouters.bookingSuccess);
          } else if (state.status == Status.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? AppStrings.unKnownError.tr())),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xffF9FAFB),
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      _buildFormSection(context),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 55.h, bottom: 40.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: ColorManager.white),
                onPressed: () => Navigator.pop(context),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorManager.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: ColorManager.gold.withValues(alpha: 0.5), width: 1),
                ),
                child: Text(
                  AppStrings.professionalFinancialConsultation.tr(),
                  style: getMediumStyle(color: ColorManager.gold, fontSize: 10.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            AppStrings.takeBusinessToNextLevel.tr(),
            style: getBoldStyle(color: ColorManager.white, fontSize: 24.sp),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.consultationFormSubtitle.tr(),
            style: getRegularStyle(
              color: ColorManager.white.withValues(alpha: 0.8),
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildLabel(AppStrings.problemDescription.tr()),
          _buildTextField(AppStrings.explainChallenges.tr(), _descriptionController, maxLines: 4),
          SizedBox(height: 20.h),
          _buildLabel(AppStrings.consultationType.tr()),
          _buildTypeToggle(),
          SizedBox(height: 20.h),
          _buildLabel(AppStrings.attachFileOptional.tr()),
          _buildUploadArea(),
          SizedBox(height: 30.h),
          BlocBuilder<ConsultationCubit, BaseState<dynamic>>(
            builder: (context, state) {
              return DefaultButtonWidget(
                text: AppStrings.sendRequest.tr(),
                isLoading: state.status == Status.loading,
                onPressed: () {
                  if (_descriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.pleaseEnterDescription.tr())),
                    );
                    return;
                  }
                  context.read<ConsultationCubit>().requestConsultation(
                        serviceId: widget.serviceId,
                        type: isChat ? 'chat' : 'call',
                        description: _descriptionController.text.trim(),
                        file: _selectedFile,
                      );
                },
                gradient: LinearGradient(
                  colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.9)],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                textColor: ColorManager.white,
                height: 55.h,
                radius: 16.r,
                isIcon: state.status != Status.loading,
                iconBuilder: Icon(Icons.send_rounded, color: ColorManager.gold, size: 20.w),
              );
            },
          ),
          SizedBox(height: 20.h),
          Center(
            child: Text(
              AppStrings.privacyPolicyAgreement.tr(),
              style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isRequired)
            Text(
              " * ",
              style: getBoldStyle(color: ColorManager.primary, fontSize: 14.sp),
            ),
          Text(
            text,
            style: getBoldStyle(color: const Color(0xff374151), fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: getRegularStyle(
          color: ColorManager.grey.withValues(alpha: 0.5),
          fontSize: 14.sp,
        ),
        fillColor: const Color(0xffF3F4F6),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: getRegularStyle(
              color: ColorManager.grey.withValues(alpha: 0.5),
              fontSize: 14.sp,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: ColorManager.grey),
          items: [],
          onChanged: (val) {},
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isChat = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: !isChat
                      ? LinearGradient(
                          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.8)],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        )
                      : null,
                  color: isChat ? Colors.transparent : null,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: !isChat
                      ? [
                          BoxShadow(
                            color: ColorManager.primary.withValues(alpha: 0.2),
                            blurRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.call.tr(),
                      style: getMediumStyle(
                        color: !isChat ? ColorManager.white : ColorManager.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.phone_outlined,
                      color: !isChat ? ColorManager.gold : ColorManager.grey,
                      size: 18.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isChat = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: isChat
                      ? LinearGradient(
                          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.8)],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        )
                      : null,
                  color: !isChat ? Colors.transparent : null,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: isChat
                      ? [
                          BoxShadow(
                            color: ColorManager.primary.withValues(alpha: 0.2),
                            blurRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.chat.tr(),
                      style: getMediumStyle(
                        color: isChat ? ColorManager.white : ColorManager.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.chat_bubble_outline,
                      color: isChat ? ColorManager.gold : ColorManager.grey,
                      size: 18.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.primary.withValues(alpha: 0.1),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [ColorManager.primary, ColorManager.gold],
              ).createShader(bounds),
              child: Icon(
                _selectedFile != null ? Icons.file_present : Icons.cloud_upload_outlined,
                color: Colors.white,
                size: 32.w,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _selectedFile != null ? _selectedFile!.path.split('/').last : AppStrings.clickToUpload.tr(),
              style: getBoldStyle(color: ColorManager.blue, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.uploadLimit.tr(),
              style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }
}
