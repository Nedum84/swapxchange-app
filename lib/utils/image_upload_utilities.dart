import 'package:swapxchange/models/product_image.dart';

class ImageUploadUtilities {
  static List<ProductImage> addImage(ProductImage imageProduct, List<ProductImage> imageProducts) {
    imageProduct.idx = imageProducts.length; //adding the index
    imageProducts.add(imageProduct);
    return imageProducts;
  }

  static List<ProductImage> updateImage(ProductImage imageProduct, List<ProductImage> imageProducts) {
    //update Image details(eg imgUrl etc)
    int index = imageProducts.indexWhere((element) => element.id == imageProduct.id);
    imageProducts.removeAt(index);
    imageProducts.insert(index, imageProduct);
    return imageProducts;
  }

  static List<ProductImage> makeImageCurrent(ProductImage imageProduct, List<ProductImage> imageProducts) {
    //update Image details(eg imgUrl etc)
    var newList = <ProductImage>[];
    for (var e in imageProducts) {
      e.isCurrent = (e.id == imageProduct.id) ? true : false;
      newList.add(e);
    }
    return newList;
  }

  static List<ProductImage> shuffleImageIndex(ProductImage coverImage, List<ProductImage> imageProducts) {
    //Making the selected Image the cover image
    // int index = imageProducts.indexWhere((element) => element.imageId==coverImage.imageId);
    int index = imageProducts.indexOf(coverImage);
    imageProducts.removeAt(index);
    imageProducts.insert(0, coverImage);
    // return imageProducts;

    List<ProductImage> newList = [];
    int i = 0;
    imageProducts.forEach((element) {
      element.idx = i;
      newList.add(element);
      print(element.toMap().toString());
      i++;
    });
    return newList;

    // OR
    // imageProducts.removeWhere((element) => element.imageId==coverImage.imageId);
    // imageProducts.insert(0, coverImage);
    // return imageProducts;
  }

  static List<ProductImage> deleteImage(ProductImage image, List<ProductImage> imageProducts) {
    //Making the selected Image the cover image
    // int index = _imageProducts.indexWhere((element) => element.imageId==coverImage.imageId);
    int index = imageProducts.indexOf(image);
    imageProducts.removeAt(index);
    // return imageProducts;

    // Dont allow it go to index 0 but to the previous one
    if (imageProducts.length > 0) {
      return (index != 0) ? makeImageCurrent(imageProducts[index - 1], imageProducts) : imageProducts;
    } else {
      return imageProducts;
    }
  }
}
