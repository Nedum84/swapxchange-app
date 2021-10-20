import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/call.dart';
import 'package:swapxchange/repository/call_methods.dart';
import 'package:swapxchange/ui/home/callscreens/pickup_screen.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final AppUser? appUser = UserController.to.user;

    return (appUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: appUser.uid!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.data() != null) {
                //there's an incoming call
                Call call = Call.fromMap(snapshot.data!.data()! as Map<String, dynamic>);

                if (!call.hasDialled!) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
            },
          )
        : Container(
            child: Center(
              child: LoadingProgressMultiColor(),
            ),
          );
  }
}
