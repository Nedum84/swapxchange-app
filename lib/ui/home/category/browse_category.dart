import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

import 'category_col.dart';
import 'sub_category_col.dart';

class BrowseCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Text(
          'Categories',
          style: H1Style,
        ),
        leading: null,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(Constants.PADDING),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: CategoryCol(),
              ),
              SizedBox(width: 16),
              Flexible(
                flex: 2,
                child: SubCategoryCol(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
