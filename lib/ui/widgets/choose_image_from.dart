import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChooseImageFrom extends StatelessWidget {
  ChooseImageFrom({required this.imageSource});

  final Function(ImageSource) imageSource;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.00)),
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            trailing: CircleAvatar(
              backgroundColor: Colors.blueGrey.withOpacity(.1),
              radius: 16,
              child: IconButton(
                iconSize: 14,
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ),
            title: Text('Choose from'),
          ),
          ListTile(
            leading: Icon(Icons.photo_camera_back),
            title: Text('Gallery'),
            onTap: () {
              imageSource(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text('Camera'),
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
