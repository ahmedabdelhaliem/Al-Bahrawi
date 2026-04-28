import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_bahrawi/app/app_functions.dart';
import 'package:al_bahrawi/common/base/base_model.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_app_bar.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/common/widgets/default_form_field.dart';
import 'package:al_bahrawi/features/contact_us/cubit/contact_us_cubit.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: AppStrings.contactUs.tr(),),
      body: Padding(
        padding: EdgeInsets.all(14.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.contactUsTitle.tr(),
                  style: getBoldStyle(fontSize: 20.sp, color: ColorManager.primary),
                ),
                SizedBox(height: 3.h),
                Text(
                  AppStrings.contactUsSubtitle.tr(),
                  style: getRegularStyle(fontSize: 12.sp, color: ColorManager.greyTextColor),
                ),
                SizedBox(height: 18.h),
                DefaultFormField(
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _nameController,
                  hintText: AppStrings.fullName.tr(),
                ),
                SizedBox(height: 10.h),
                DefaultFormField(
                  keyboardType: TextInputType.phone,
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _phoneController,
                  hintText: AppStrings.phoneNumber.tr(),
                ),
                SizedBox(height: 10.h),
                DefaultFormField(
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _emailController,
                  hintText: AppStrings.emailAddress.tr(),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10.h),
                DefaultFormField(
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _subjectController,
                  hintText: AppStrings.contactSubject.tr(),
                ),
                SizedBox(height: 10.h),
                DefaultFormField(
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _messageController,
                  hintText: AppStrings.message.tr(),
                  maxLines: 5,
                ),
                SizedBox(height: 18.h),
                BlocProvider(
                  create: (context) => ContactUsCubit(),
                  child: BlocConsumer<ContactUsCubit, BaseState<BaseModel>>(
                    listener: (context, state) {
                      if (state.status == Status.success) {
                        _nameController.clear();
                        _phoneController.clear();
                        _emailController.clear();
                        _subjectController.clear();
                        _messageController.clear();
                        AppFunctions.showsToast(state.data?.message ?? AppStrings.messageSentSuccessfully.tr(), ColorManager.successGreen, context);
                      } else if (state.status == Status.failure) {
                        AppFunctions.showsToast(state.errorMessage ?? AppStrings.unKnownError.tr(), ColorManager.red, context);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state.status == Status.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: DefaultButtonWidget(
                          onPressed: () {
                              context.read<ContactUsCubit>().contactUs(
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                subject: _subjectController.text,
                                message: _messageController.text,
                              );
                          },
                          text: AppStrings.sendMessage.tr(),
                          color: ColorManager.primary,
                          textColor: ColorManager.white,
                          fontSize: 13.sp,
                          isLoading: isLoading,
                        ),
                      );
                    },
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
