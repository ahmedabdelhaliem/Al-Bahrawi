// import 'package:al_bahrawi/app/app_functions.dart';
// import 'package:al_bahrawi/common/base/base_model.dart';
// import 'package:al_bahrawi/common/base/base_state.dart';
// import 'package:al_bahrawi/common/resources/color_manager.dart';
// import 'package:al_bahrawi/common/resources/strings_manager.dart';
// import 'package:al_bahrawi/common/resources/styles_manager.dart';
// import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
// import 'package:al_bahrawi/common/widgets/default_error_widget.dart';
// import 'package:al_bahrawi/common/widgets/default_form_field.dart';
// import 'package:al_bahrawi/common/widgets/default_loading_widget.dart';
// import 'package:al_bahrawi/features/auth/signup/models/signup_model.dart';
// import 'package:al_bahrawi/features/profile/main%20profile/cubit/profile_cubit.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:io';

// import 'package:image_picker/image_picker.dart';
// import 'package:al_bahrawi/features/profile/main%20profile/cubit/update_profile_cubit.dart';

// class EditProfileView extends StatefulWidget {
//   const EditProfileView({super.key});

//   @override
//   State<EditProfileView> createState() => _EditProfileViewState();
// }

// class _EditProfileViewState extends State<EditProfileView> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   String? _imageUrl;
//   bool _isEditMode = false;
//   File? _pickedImageFile;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileCubit>().fetchProfile();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   void _fillFields(SignupModel profile) {
//     _nameController.text = '';
//     _emailController.text = '';
//     _phoneController.text = '';
//     _imageUrl = '';
//   }

//   void _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _pickedImageFile = File(picked.path);
//         _imageUrl = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           AppStrings.editProfile.tr(),
//           style: getBoldStyle(fontSize: 16.sp, color: ColorManager.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: ColorManager.black),
//       ),
//       body: BlocConsumer<ProfileCubit, BaseState>(
//         listener: (context, state) {
//           if (state.isSuccess) {
//             _fillFields(state.data!);
//             _isEditMode = false;
//             setState(() {});
//           }
//         },
//         builder: (context, state) {
//           if (state.status == Status.loading) {
//             return DefaultLoadingWidget();
//           }
//           if (state.status == Status.failure) {
//             return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
//           }
//           return Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Stack(
//                       children: [
//                         CircleAvatar(
//                           radius: 61.r,
//                           backgroundColor: ColorManager.lightGrey,
//                           child: CircleAvatar(
//                             radius: 60.r,
//                             backgroundImage:
//                                 (_imageUrl != null && _imageUrl!.length > 40
//                                         ? NetworkImage(_imageUrl!)
//                                         : (_pickedImageFile?.path ?? '')
//                                               .isNotEmpty
//                                         ? FileImage(_pickedImageFile!)
//                                         : null)
//                                     as ImageProvider?,
//                             backgroundColor: ColorManager.lightGrey,
//                           ),
//                         ),
//                         if (_isEditMode)
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: InkWell(
//                               onTap: _pickImage,
//                               child: CircleAvatar(
//                                 radius: 16.r,
//                                 backgroundColor: ColorManager.primary,
//                                 child: const Icon(
//                                   Icons.edit,
//                                   color: Colors.white,
//                                   size: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   DefaultFormField(
//                     controller: _nameController,
//                     enabled: _isEditMode == true ? true : false,
//                     noBorder: false,
//                     borderColor: ColorManager.greyBorder,
//                     hintText: AppStrings.fullName.tr(),
//                     title: AppStrings.fullName.tr(),
//                     titleStyle: getSemiBoldStyle(
//                       fontSize: 15.sp,
//                       color: ColorManager.greyTextColor,
//                     ),
//                     textStyle: getRegularStyle(
//                       fontSize: 15.sp,
//                       color: ColorManager.blackText,
//                     ),
//                     isUnderLine: true,
//                   ),
//                   SizedBox(height: 15.h),
//                   DefaultFormField(
//                     controller: _emailController,
//                     enabled: false,
//                     noBorder: false,
//                     borderColor: ColorManager.greyBorder,
//                     hintText: AppStrings.emailAddress.tr(),
//                     title: AppStrings.emailAddress.tr(),
//                     titleStyle: getSemiBoldStyle(
//                       fontSize: 15.sp,
//                       color: ColorManager.greyTextColor,
//                     ),
//                     textStyle: getRegularStyle(
//                       fontSize: 15.sp,
//                       color: ColorManager.blackText,
//                     ),
//                     isUnderLine: true,
//                   ),

//                   SizedBox(height: 15.h),
//                   DefaultFormField(
//                     controller: _phoneController,
//                     enabled: _isEditMode == true ? true : false,
//                     noBorder: false,
//                     borderColor: ColorManager.greyBorder,
//                     hintText: AppStrings.phoneNumber.tr(),
//                     title: AppStrings.phoneNumber.tr(),
//                     titleStyle: getSemiBoldStyle(
//                       fontSize: 15.sp,
//                       color: ColorManager.greyTextColor,
//                     ),
//                     textStyle: getRegularStyle(
//                       fontSize: 15.sp,
//                       color: ColorManager.blackText,
//                     ),
//                     isUnderLine: true,
//                   ),

//                   SizedBox(height: 30.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: BlocProvider(
//                           create: (context) => UpdateProfileCubit(),
//                           child:
//                               BlocConsumer<
//                                 UpdateProfileCubit,
//                                 BaseState<BaseModel>
//                               >(
//                                 listener: (context, state) {
//                                   if (state.status == Status.failure) {
//                                     AppFunctions.showsToast(
//                                       state.errorMessage!,
//                                       ColorManager.red,
//                                       context,
//                                     );
//                                   }
//                                   if (state.isSuccess) {
//                                     context.read<ProfileCubit>().fetchProfile();
//                                   }
//                                 },
//                                 builder: (context, state) {
//                                   return DefaultButtonWidget(
//                                     onPressed: () {
//                                       if (!_isEditMode) {
//                                         setState(() {
//                                           _isEditMode = true;
//                                         });
//                                         return;
//                                       }
//                                       if (_formKey.currentState!.validate()) {
//                                         context
//                                             .read<UpdateProfileCubit>()
//                                             .updateProfile(
//                                               name: _nameController.text,
//                                               email: _emailController.text,
//                                               phone: _phoneController.text,
//                                               image: _pickedImageFile?.path,
//                                             );
//                                       }
//                                     },
//                                     color: ColorManager.primary,
//                                     textColor: ColorManager.white,
//                                     text: _isEditMode
//                                         ? AppStrings.save.tr()
//                                         : AppStrings.edit.tr(),
//                                     isLoading: state.status == Status.loading,
//                                   );
//                                 },
//                               ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
