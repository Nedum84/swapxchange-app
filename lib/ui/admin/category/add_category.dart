import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapxchange/enum/storage_enum.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/repository/repo_category.dart';
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

class AddCategory extends StatefulWidget {
  final Category? category;

  AddCategory({Key? key, this.category}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final RepoStorage _storageMethods = RepoStorage();
  TextEditingController catNameController = TextEditingController();

  String imageUrl = "";
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      setState(() {
        isEditing = true;
        imageUrl = widget.category!.categoryIcon!;
        catNameController.text = widget.category!.categoryName ?? "";
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
    final catName = catNameController.text.toString().trim();
    if (catName.isEmpty) {
      AlertUtils.toast('Category name is required');
    } else if (imageUrl.isEmpty) {
      AlertUtils.toast('Category banner is required');
    } else {
      AlertUtils.showProgressDialog(title: null);
      //Upload Banner/Icon if not already uploaded
      if (!imageUrl.contains('https')) {
        //--> Delete the previous one
        if (isEditing) await _storageMethods.delete(widget.category!.categoryIcon!, StorageEnum.CATEGORY);
        //Upload the new one
        final selectedImage = File(imageUrl);
        final String? uploadedImgPath = await _storageMethods.uploadFile(selectedImage, StorageEnum.CATEGORY);
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
        edit(catName);
      } else {
        addNew(catName);
      }
    }
  }

  addNew(String catName) async {
    final newCat = Category(
      categoryName: catName,
      categoryIcon: imageUrl,
    );

    final createCat = await RepoCategory.addCategory(category: newCat);
    if (createCat == null) {
      AlertUtils.toast('Error adding category');
      AlertUtils.hideProgressDialog();
    } else {
      AlertUtils.hideProgressDialog();
      Get.back(result: createCat);
    }
  }

  edit(String catName) async {
    final newCat = widget.category!;
    newCat.categoryName = catName;
    newCat.categoryIcon = imageUrl;

    final createCat = await RepoCategory.editCategory(category: newCat);
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
          title: isEditing ? 'Edit Category' : 'Add Category',
          titleFontSize: 18,
          actionBtn: [
            InkWell(
              onTap: onSubmit,
              child: Row(
                children: [
                  Icon(Icons.check, color: KColors.PRIMARY),
                  Text(
                    widget.category != null ? "Save changes" : 'Submit',
                    style: StyleNormal.copyWith(
                      color: KColors.PRIMARY,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          Text('Category name'),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
              color: Colors.white,
            ),
            child: CustomTextField(controller: catNameController),
          ),
          SizedBox(height: 24),
          Text('Category banner'),
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
