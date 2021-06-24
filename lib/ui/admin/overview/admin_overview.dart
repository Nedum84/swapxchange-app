import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/admin/category/admin_category.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class AdminOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
        child: CustomAppbar(
          title: 'Admin Portal',
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Container(
              color: Colors.white,
              child: ListTile(
                onTap: () => Get.to(() => AdminCategory()),
                title: Text(
                  'Our Categories',
                  style: StyleNormal,
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: KColors.TEXT_COLOR),
              ),
            )
          ],
        ),
      ),
    );
  }
}
