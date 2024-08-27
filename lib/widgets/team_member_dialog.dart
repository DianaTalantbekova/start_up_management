import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:start_up_management/resources/app_styles.dart';
import 'package:start_up_management/widgets/custom_text_field.dart';
import '../resources/app_colors.dart';

class TeamMemberDialog extends StatefulWidget {
  const TeamMemberDialog({
    super.key,
    required this.name,
    required this.asset,
    this.title,
  });

  final String name;
  final String asset;
  final String? title;

  @override
  _TeamMemberDialogState createState() => _TeamMemberDialogState();
}

class _TeamMemberDialogState extends State<TeamMemberDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  File? _imageFile;

  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _positionController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isNameNotEmpty = _nameController.text.isNotEmpty;
    final isPositionNotEmpty = _positionController.text.isNotEmpty;
    _isFormValid.value = isNameNotEmpty || isPositionNotEmpty;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _onAdd() {
    Navigator.pop(
      context,
      {
        'name': _nameController.text,
        'position': _positionController.text,
        'image': _imageFile,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.black212121,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 24.w),
                  Text(
                    widget.title ?? 'Team members',
                    style: AppStyles.helper3,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/icons/cross.svg',
                      fit: BoxFit.contain,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.grayA2A9B8,
                    image: _imageFile != null
                        ? DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _imageFile == null
                      ? Center(
                    child: Text(
                      widget.name,
                      style: AppStyles.helper3,
                    ),
                  )
                      : null,
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _nameController,
                hintText: 'Name',
                color: AppColors.black212121,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                hintText: 'Position',
                color: AppColors.black212121,
                controller: _positionController,
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        alignment: Alignment.center,
                        height: 51.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.r),
                          color: AppColors.black212121,
                        ),
                        child: Text(
                          'Delete',
                          style: AppStyles.helper1.copyWith(color: AppColors.red),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isFormValid,
                      builder: (context, isFormValid, child) {
                        return GestureDetector(
                          onTap: isFormValid ? _onAdd : null,
                          child: Container(
                            alignment: Alignment.center,
                            height: 51.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color:
                                   AppColors.blue1C4DFA

                            ),
                            child: Text(
                              'Add',
                              style: AppStyles.helper1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}