import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class InviteFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constants.PADDING,
        horizontal: 24,
      ),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Image.asset(
            'images/invitation.png',
            width: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Invite friends',
            style: H2Style,
          ),
          SizedBox(height: 16),
          Text(
            'Earn 200 coins for each friend that joins using your link',
            style: StyleNormal,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ButtonSmall(
            onClick: () => Share.share(Constants.SHARE_CONTENT, subject: 'Share via'),
            text: 'Invite friends',
            // textColor: Colors.white,
            // bgColor: KColors.PRIMARY,
            radius: 8,
            py: 8,
          )
        ],
      ),
    );
  }
}
