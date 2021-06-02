import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:swapxchange/enum/online_status.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/home/tabs/profile/profile.dart';
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
        color: Colors.blueGrey,
      ),
      onPressed: () => Get.back(),
    ),
    centerTitle: false,
    title: InkWell(
      onTap: () => Get.to(() => Profile()),
      child: Row(
        children: [
          receiverUser.profilePhoto != ""
              ? CachedImage(
                  receiverUser.profilePhoto ?? "",
                  radius: 40,
                  isRound: true,
                  alt: ImagePlaceholder.User,
                )
              : CircleAvatar(
                  backgroundColor: KColors.TEXT_COLOR.withOpacity(.1),
                  child: Icon(
                    FontAwesomeIcons.userAlt,
                    color: Colors.black26,
                    size: 18,
                  ),
                ),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receiverUser.name!,
                style: StyleNormal.copyWith(color: Colors.blueGrey, fontSize: 16),
              ),
              UserOnlineStatus(
                appUser: receiverUser,
              ),
              // Text('online', style: StyleNormal.copyWith(color: Colors.green),),
            ],
          ),
        ],
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.video_call,
          color: Colors.blueGrey,
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
          color: Colors.blueGrey,
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
        AppUser? user;

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Container();
        }

        user = AppUser.fromMap(snapshot.data!.data()!);
        return Text(
          user.onlineStatus ?? "offline",
          style: StyleNormal.copyWith(color: getColor(user.onlineStatus!), fontSize: 12),
        );
      },
    );
  }
}
