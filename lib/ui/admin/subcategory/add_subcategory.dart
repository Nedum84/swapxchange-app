import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapxchange/enum/storage_enum.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/repository/repo_sub_category.dart';
import 'package:swapxchange/repository/storage_methods.dart';
import 'package:swapxchange/ui/admin/category/widgets/added_image_preview.dart';
import 'package:swapxchange/ui/admin/category/widgets/admin_add_image.dart';
import 'package:swapxchange/ui/widgets/choose_image_from.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/styles.dart';

class AddSubCategory extends StatefulWidget {
  final SubCategory? subCategory;
  final Category category;

  AddSubCategory({Key? key, this.subCategory, required this.category}) : super(key: key);

  @override
  _AddSubCategoryState createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  final RepoStorage _storageMethods = RepoStorage();
  TextEditingController subCatNameController = TextEditingController();

  String imageUrl = "";
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.subCategory != null) {
      setState(() {
        isEditing = true;
        imageUrl = widget.subCategory!.subCategoryIcon!;
        subCatNameController.text = widget.subCategory!.subCategoryName ?? "";
      });
    }
  }

  _pickImageSheet() {
    Get.bottomSheet(
      ChooseImageFrom(
        imageSource: (source) => pickImage(source: source),
      ),
    );
  }

  void pickImage({required ImageSource source}) async {
    File? selectedImage = await Helpers.pickImage(source: source);
    if (selectedImage != null) {
      setState(() => imageUrl = selectedImage.path);
    }
  }

  onSubmit() async {
    final subCatName = subCatNameController.text.toString().trim();
    if (subCatName.isEmpty) {
      AlertUtils.toast('Sub Category name is required');
    } else if (imageUrl.isEmpty) {
      AlertUtils.toast('Banner/Icon is required');
    } else {
      AlertUtils.showProgressDialog(title: null);
      //Upload Banner/Icon if not already uploaded
      if (!imageUrl.contains('https')) {
        //--> Delete the previous one
        if (isEditing) await _storageMethods.delete(widget.subCategory!.subCategoryIcon!, StorageEnum.SUBCATEGORY);
        //Upload the new one
        final selectedImage = File(imageUrl);
        final String? uploadedImgPath = await _storageMethods.uploadFile(selectedImage, StorageEnum.SUBCATEGORY);
        if (uploadedImgPath == null || uploadedImgPath == "") {
          AlertUtils.toast('Error uploading image');
          AlertUtils.hideProgressDialog();
          return;
        } else {
          setState(() => imageUrl = uploadedImgPath);
        }
      }
      //--> Check editing
      if (isEditing) {
        edit(subCatName);
      } else {
        addNew(subCatName);
      }
    }
  }

  addNew(String catName) async {
    final newSubCat = SubCategory(
      subCategoryName: catName,
      subCategoryIcon: imageUrl,
      categoryId: widget.category.categoryId!,
    );

    final createCat = await RepoSubCategory.add(subCategory: newSubCat);
    if (createCat == null) {
      AlertUtils.toast('Error adding sub category');
      AlertUtils.hideProgressDialog();
    } else {
      AlertUtils.hideProgressDialog();
      Get.back(result: createCat);
    }
  }

  edit(String subCatName) async {
    final newSubCat = widget.subCategory!;
    newSubCat.subCategoryName = subCatName;
    newSubCat.subCategoryIcon = imageUrl;

    final createCat = await RepoSubCategory.edit(subCategory: newSubCat);
    if (createCat == null) {
      AlertUtils.toast('Error saving changes');
      AlertUtils.hideProgressDialog();
    } else {
      AlertUtils.hideProgressDialog();
      Get.back(result: createCat);
    }
  }

  @override
  Widget build(BuildContext context) {
    // AlertUtils.hideProgressDialog();

    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
        child: CustomAppbar(
          title: isEditing ? 'Edit Sub Category' : 'Add Sub Category',
          titleFontSize: 18,
          actionBtn: [
            InkWell(
              onTap: onSubmit,
              child: Row(
                children: [
                  Icon(Icons.check, color: KColors.PRIMARY),
                  Text(
                    isEditing ? "Save changes" : 'Submit',
                    style: StyleNormal.copyWith(
                      color: KColors.PRIMARY,
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          Text('Sub Category name'),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
              color: Colors.white,
            ),
            child: CustomTextField(controller: subCatNameController),
          ),
          SizedBox(height: 24),
          Text('Select banner'),
          SizedBox(height: 8),
          if (imageUrl.isEmpty) AddImage(onClick: _pickImageSheet),
          if (imageUrl.isNotEmpty)
            AddedImagePreview(
              onDoubleClick: _pickImageSheet,
              imgUrl: imageUrl,
            )
        ],
      ),
    );
  }
}
