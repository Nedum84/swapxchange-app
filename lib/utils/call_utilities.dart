import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/call.dart';
import 'package:swapxchange/repository/call_methods.dart';
import 'package:swapxchange/ui/home/callscreens/call_screen.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/helpers.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({required AppUser from, required AppUser to, useVideo = true}) async {
    final int callUid = int.parse("${from.userId}${to.userId}");
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
      // enter log
      // LogRepository.addLogs(log);

      Get.to(() => CallScreen(call: call, clientRole: ClientRole.Broadcaster));
    }
  }
}
