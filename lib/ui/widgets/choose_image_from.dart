import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/bottomsheet_container.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class ChooseImageFrom extends StatelessWidget {
  ChooseImageFrom({required this.imageSource});

  final Function(ImageSource) imageSource;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: 'Choose from',
      sheetHeight: 250,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.photo_camera_back,
              color: KColors.TEXT_COLOR_DARK,
            ),
            title: Text(
              'Gallery',
              style: StyleNormal.copyWith(
                fontSize: 16,
                color: KColors.TEXT_COLOR_DARK,
              ),
            ),
            onTap: () {
              imageSource(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.photo_camera,
              color: KColors.TEXT_COLOR_DARK,
            ),
            title: Text(
              'Camera',
              style: StyleNormal.copyWith(
                fontSize: 16,
                color: KColors.TEXT_COLOR_DARK,
              ),
            ),
            onTap: () {
              imageSource(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
