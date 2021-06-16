import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class UserDetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white70,
              boxShadow: [Constants.SHADOW],
              borderRadius: BorderRadius.circular(50),
            ),
            child: CachedImage(
              userController.user!.profilePhoto!,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              radius: 50,
              alt: ImagePlaceholder.User,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userController.user!.name!,
                    style: H2Style,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xffCD4F4E).withOpacity(.8),
                        size: 18,
                      ),
                      Expanded(
                        child: Text(
                          userController.user!.address!,
                          style: StyleCategorySubTitle,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
