import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/home/product/addproduct/upload/image_listview.dart';
import 'package:swapxchange/ui/home/product/addproduct/upload/image_viewpager.dart';
import 'package:swapxchange/ui/widgets/choose_image_from.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/image_upload_utilities.dart';

class UploadHome extends StatefulWidget {
  UploadHome({required this.imageProducts, required this.showAddImageDialog});

  final List<ProductImage> imageProducts;
  final bool showAddImageDialog;

  @override
  _UploadHomeState createState() => _UploadHomeState();
}

class _UploadHomeState extends State<UploadHome> {
  List<ProductImage> _imageProducts = [];
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    _imageProducts = widget.imageProducts;

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      if (widget.showAddImageDialog) _showFileChooser();
    });
  }

  void selectImage(ImageSource source) async {
    var pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      var imgFile = File(pickedImage.path);
      setState(() => showSpinner = true);
      var imgFileCompressed = await Helpers.compressImage(imgFile);
      setState(() => showSpinner = false);

      // String _imagePath = pickedImage.path;
      String _imagePath = imgFileCompressed!.path;
      String imgId = Helpers.genRandString();
      ProductImage newImageProduct = ProductImage(
        // id: imgId,
        // productId: productProvider.product.productId,
        imagePath: _imagePath,
      );
      //
      // _imageProducts = ImageUploadUtilities.addImage(newImageProduct, _imageProducts);
      // setState(() {
      //   _imageProducts = ImageUploadUtilities.makeImageCurrent(newImageProduct, _imageProducts);
      // });

      // ImageProduct iProduct= await ImageMethods.uploadImageProduct(imageProduct: _newImageProduct);
      // if(iProduct!=null)
      //   productProvider.updateImage(iProduct);
      // else
      //   print('Image not uploaded');

    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _imageProducts);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blueGrey[100],
                    child: Stack(
                      children: [
                        ImageViewpager(
                          currentScrolled: (imageProduct) {
                            setState(() {
                              _imageProducts = ImageUploadUtilities.makeImageCurrent(imageProduct, _imageProducts);
                            });
                          },
                          imageProducts: _imageProducts,
                          deleteImage: (imageProduct) {
                            setState(() {
                              _imageProducts = ImageUploadUtilities.deleteImage(imageProduct, _imageProducts);
                            });
                          },
                          makeCover: (imageProduct) {
                            setState(() {
                              _imageProducts = ImageUploadUtilities.shuffleImageIndex(imageProduct, _imageProducts);
                            });
                          },
                        ),
                        Positioned(
                          top: 25,
                          left: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context, _imageProducts),
                              icon: Icon(Icons.arrow_back),
                              color: Colors.blueGrey,
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
                      imageProducts: _imageProducts,
                      onImageClick: (imageProduct) {
                        setState(() {
                          _imageProducts = ImageUploadUtilities.makeImageCurrent(imageProduct, _imageProducts);
                        });
                      },
                      addImageClick: () => _showFileChooser(),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showFileChooser() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return ChooseImageFrom(
          imageSource: (source) => selectImage(source),
        );
      },
    );
  }
}
