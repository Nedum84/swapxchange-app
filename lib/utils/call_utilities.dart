import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/call.dart';
import 'package:swapxchange/models/notification_model.dart';
import 'package:swapxchange/repository/call_methods.dart';
import 'package:swapxchange/repository/notification_repo.dart';
import 'package:swapxchange/ui/home/callscreens/call_screen.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/helpers.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({required AppUser from, required AppUser to, useVideo = true}) async {
    final String callUid = "${from.userId}-${to.userId}";
    final String channelName = Helpers.genRandString();
    final String? callToken = await CallMethods.generateCallToken(uid: callUid, channelName: channelName);

    if (callToken == null || callToken.isEmpty) {
      AlertUtils.toast('Error connecting to the other user. CODE: TOKEN');
      return;
    }

    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: channelName,
      callToken: callToken,
      callUid: callUid,
      useVideo: useVideo,
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      //Send PUSH Notification
      if (to.notification!.chat != 0) {
        final notRepo = NotificationRepo();
        final model = NotificationModel(
          data: NotificationData(
            type: NotificationType.CALL,
            id: to.userId.toString(),
            idSecondary: call.callUid.toString(),
            payload: call.toMap(call).toString(),
          ),
          notification: PushNotification(
            title: ' ${call.useVideo! ? "Video" : "Voice"} Call from ${from.name} ',
            body: "Click to answer before it ends ",
          ),
        );
        notRepo.sendNotification(tokens: [to.deviceToken!], model: model);
      }
      Get.to(() => CallScreen(call: call, clientRole: ClientRole.Broadcaster));
    }
  }
}
