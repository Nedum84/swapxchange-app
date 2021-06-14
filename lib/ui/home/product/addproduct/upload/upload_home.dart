import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/repository/image_methods.dart';
import 'package:swapxchange/ui/home/product/addproduct/upload/image_listview.dart';
import 'package:swapxchange/ui/home/product/addproduct/upload/image_viewpager.dart';
import 'package:swapxchange/ui/widgets/choose_image_from.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/image_upload_utilities.dart';

class UploadHome extends StatefulWidget {
  UploadHome({required this.showAddImageDialog});

  final bool showAddImageDialog;

  @override
  _UploadHomeState createState() => _UploadHomeState();
}

class _UploadHomeState extends State<UploadHome> {
  AddProductController addController = AddProductController.to;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      if (widget.showAddImageDialog) _showFileChooser();
    });
  }

  void selectImage(ImageSource source) async {
    File? selectedImage = await Helpers.pickImage(source: source);
    if (selectedImage != null) {
      String? imgUrl = await ImageMethods.uploadSingleImage(imageFile: selectedImage);
      if (imgUrl != null) {
        final imgP = ProductImage(
          id: 0,
          productId: 0,
          imagePath: imgUrl,
          idx: 0,
        );
        ImageUploadUtilities.addImage(imgP);
      } else {
        AlertUtils.toast('Error occurred while uploading your image.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        brightness: Brightness.light,
        backgroundColor: KColors.WHITE_GREY,
        shadowColor: Colors.transparent,
      ),
      body: GetBuilder<AddProductController>(builder: (addController) {
        return Container(
          padding: EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: KColors.WHITE_GREY,
                  child: Stack(
                    children: [
                      ImageViewpager(
                        deleteImage: (imageProduct) {
                          ImageUploadUtilities.deleteImage(imageProduct);
                        },
                        makeCover: (imageProduct) {
                          ImageUploadUtilities.shuffleImageIndex(imageProduct);
                        },
                      ),
                      Positioned(
                        top: 25,
                        left: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          // radius: 25,
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(Icons.close),
                            color: KColors.TEXT_COLOR,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: 120,
                color: Colors.white,
                child: ImageListView(
                  onImageClick: (imageProduct) {
                    ImageUploadUtilities.makeImageCurrent(imageProduct);
                  },
                  addImageClick: () => _showFileChooser(),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  _showFileChooser() {
    Get.bottomSheet(
      ChooseImageFrom(
        imageSource: (source) => selectImage(source),
      ),
    );
  }
}
