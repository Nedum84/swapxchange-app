import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/dump/sliver_header2.dart';
import 'package:swapxchange/enum/online_status.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/call_utilities.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/permissions.dart';
import 'package:swapxchange/utils/styles.dart';

AppBar chatAppBar({required AppUser receiverUser, required AppUser currentUser}) {
  return AppBar(
    backgroundColor: Colors.white,
    shadowColor: Colors.transparent,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: KColors.TEXT_COLOR_DARK,
      ),
      onPressed: () => Get.back(),
    ),
    centerTitle: false,
    title: InkWell(
      onTap: () => Get.to(() => SliverHeader2()),
      child: Row(
        children: [
          CachedImage(
            receiverUser.profilePhoto ?? "",
            radius: 40,
            isRound: true,
            alt: ImagePlaceholder.User,
          ),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receiverUser.name!,
                style: StyleNormal.copyWith(
                  color: KColors.TEXT_COLOR_DARK,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              UserOnlineStatus(
                appUser: receiverUser,
              ),
            ],
          ),
        ],
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.videocam_rounded,
          color: KColors.TEXT_COLOR_DARK,
        ),
        onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted()
            ? CallUtils.dial(
                from: currentUser,
                to: receiverUser,
                useVideo: true,
              )
            : {},
      ),
      IconButton(
        icon: Icon(
          Icons.phone,
          color: KColors.TEXT_COLOR_DARK,
        ),
        onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted()
            ? CallUtils.dial(
                from: currentUser,
                to: receiverUser,
                useVideo: false,
              )
            : {},
      )
    ],
  );
}

class UserOnlineStatus extends StatelessWidget {
  final AppUser appUser;

  UserOnlineStatus({required this.appUser});

  getColor(String onlineStatus) {
    if (onlineStatus == EnumToString.convertToString(OnlineStatus.ONLINE).toLowerCase()) {
      return Colors.green;
    } else if (onlineStatus == EnumToString.convertToString(OnlineStatus.OFFLINE).toLowerCase()) {
      return Colors.grey;
    } else if (onlineStatus == EnumToString.convertToString(OnlineStatus.AWAY).toLowerCase()) {
      return Colors.orange;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: AuthRepo.getUserStream(uid: appUser.uid!),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Container();
        }
        final onlineStatus = snapshot.data!.data()?['online_status'];

        return Text(
          onlineStatus ?? "offline",
          style: StyleNormal.copyWith(color: getColor(onlineStatus!), fontSize: 12),
        );
      },
    );
  }
}
