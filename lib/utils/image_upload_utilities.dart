import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/models/product_image.dart';

AddProductController addProductController = AddProductController.to;

class ImageUploadUtilities {
  static addImage(ProductImage imageProduct) {
    final imageProducts = addProductController.imageList;
    imageProduct.idx = imageProducts.length; //adding the index
    imageProducts.add(imageProduct);
    addProductController.setImgList(imageProducts);
  }

  static updateImage(ProductImage imageProduct) {
    final imageProducts = addProductController.imageList;
    //update Image details(eg imgUrl etc)
    int index = imageProducts.indexWhere((element) => element.imagePath == imageProduct.imagePath);
    imageProducts.removeAt(index);
    imageProducts.insert(index, imageProduct);
    addProductController.setImgList(imageProducts);
  }

  static makeImageCurrent(ProductImage imageProduct) {
    final list = addProductController.imageList;
    var newList = <ProductImage>[];
    for (var e in list) {
      e.isCurrent = (e.imagePath == imageProduct.imagePath) ? true : false;
      newList.add(e);
    }
    addProductController.setImgList(newList);
  }

  static shuffleImageIndex(ProductImage coverImage) {
    final imageProducts = addProductController.imageList;

    imageProducts.removeWhere((element) => element.imagePath == coverImage.imagePath);
    imageProducts.insert(0, coverImage);

    List<ProductImage> newList = [];
    int i = 0;
    imageProducts.forEach((element) {
      element.idx = i;
      newList.add(element);
      print(element.toMap().toString());
      i++;
    });
    addProductController.setImgList(newList);
  }

  static deleteImage(ProductImage image) {
    final imageProducts = addProductController.imageList;
    int index = imageProducts.indexOf(image);
    imageProducts.removeAt(index);

    // Dont allow it go to index 0 but to the previous one
    if (imageProducts.length > 0) {
      if (index != 0)
        makeImageCurrent(imageProducts[index - 1]);
      else
        addProductController.setImgList(imageProducts);
    } else {
      addProductController.setImgList(imageProducts);
    }
  }
}
