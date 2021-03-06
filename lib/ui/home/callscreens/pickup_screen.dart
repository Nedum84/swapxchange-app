import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/call.dart';
import 'package:swapxchange/repository/call_methods.dart';
import 'package:swapxchange/ui/home/callscreens/call_screen.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/permissions.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();

  bool isCallMissed = true;

  @override
  void dispose() {
    if (isCallMissed) {
      // addToLocalStorage(callStatus: CALL_STATUS_MISSED);//OR add to firebase storage chat collection
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            CachedImage(
              widget.call.callerPic!,
              isRound: true,
              radius: 180,
              alt: ImagePlaceholder.User,
            ),
            SizedBox(height: 15),
            Text(
              widget.call.callerName!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: KColors.TEXT_COLOR.withOpacity(.1),
                  child: IconButton(
                    icon: Icon(Icons.call_end),
                    color: KColors.RED,
                    onPressed: () async {
                      isCallMissed = false;
                      await callMethods.endCall(call: widget.call).then((callEnded) {
                        if (callEnded) Navigator.of(context).pop();
                      }).catchError((e) => print(e));
                    },
                  ),
                ),
                SizedBox(width: 25),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: KColors.TEXT_COLOR.withOpacity(.1),
                  child: IconButton(
                      icon: Icon(Icons.call),
                      color: KColors.PRIMARY,
                      onPressed: () async {
                        isCallMissed = false;
                        // addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                        await Permissions.cameraAndMicrophonePermissionsGranted()
                            ? Get.to(
                                () => CallScreen(
                                  call: widget.call,
                                  clientRole: ClientRole.Audience,
                                ),
                              )
                            : {};
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
