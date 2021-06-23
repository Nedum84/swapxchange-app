import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/bottomsheet_container.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class NotificationModal extends StatefulWidget {
  @override
  _NotificationModalState createState() => _NotificationModalState();
}

class _NotificationModalState extends State<NotificationModal> {
  AppUser updatedUser = UserController.to.user!;
  late NotificationSetting notificationSetting;

  @override
  void initState() {
    super.initState();
    notificationSetting = updatedUser.notification!;
  }

  saveChanges() {
    updatedUser.notification = notificationSetting;
    AlertUtils.showProgressDialog(title: null);
    AuthRepo().updateUserDetails(
      appUser: updatedUser,
      onSuccess: (appUser) {
        AlertUtils.hideProgressDialog();
        AlertUtils.hideProgressDialog();
        if (appUser != null) {
          UserController.to.setUser(appUser);
          AlertUtils.toast('Saved changes');
        }
      },
      onError: (er) {
        AlertUtils.hideProgressDialog();
        AlertUtils.alert('$er');
        print("$er");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: 'Notification',
      child: Expanded(
        child: ListView(
          children: [
            InfoList(
                title: 'General',
                status: notificationSetting.general == 1,
                onChanged: (status) {
                  setState(() => notificationSetting.general = status == true ? 1 : 0);
                }),
            InfoList(
                title: "Chats",
                status: notificationSetting.chat == 1,
                onChanged: (status) {
                  setState(() => notificationSetting.chat = status == true ? 1 : 0);
                }),
            InfoList(
                title: "Nearby products",
                status: notificationSetting.product == 1,
                onChanged: (status) {
                  setState(() => notificationSetting.product = status == true ? 1 : 0);
                }),
            InfoList(
                title: "Calls",
                status: notificationSetting.call == 1,
                onChanged: (status) {
                  setState(() => notificationSetting.call = status == true ? 1 : 0);
                }),
            SizedBox(height: 16),
            PrimaryButton(
              onClick: saveChanges,
              btnText: 'Save changes',
              bgColor: KColors.PRIMARY,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class InfoList extends StatelessWidget {
  InfoList({required this.title, required this.status, required this.onChanged});

  final String title;
  final bool status;
  final Function(bool state) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_DARK, fontSize: 16),
      ),
      trailing: Platform.isAndroid
          ? Switch(
              onChanged: onChanged,
              value: status,
              activeColor: KColors.PRIMARY,
            )
          : CupertinoSwitch(
              onChanged: onChanged,
              value: status,
              activeColor: KColors.PRIMARY,
            ),
    );
  }
}
