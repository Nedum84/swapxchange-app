import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/colors.dart';

class AlertUtils {
  static void alert(String content, {required BuildContext context, String? title}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: (title != null) ? Text(title) : Container(),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  static confirm(String content, {required BuildContext context, String? title, String positiveBtnText = 'OK', String negativeBtnText = 'CANCEL', Function? okCallBack, bool fromTop = true, bool expandHeight = false}) {
    showGeneralDialog(
      // barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
              child: Column(
                children: [
                  Container(
                    // height: (expandHeight) ? 250 : 180,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.only(bottom: 50, left: 12, right: 12, top: 80),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        if (title != null) Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        if (title != null) SizedBox(height: 8),
                        Text(
                          content,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: KColors.RED.withOpacity(0.6),
                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                ),
                                child: Text(
                                  negativeBtnText,
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () {
                                okCallBack!();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: KColors.PRIMARY.withOpacity(0.6),
                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                ),
                                child: Text(
                                  positiveBtnText,
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, anim2, child) {
        return SlideTransition(
          // position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          //If you want to start with custom position, then all you can do is change begin: Offset(0, 1) to begin: Offset(0.2, 1)
          position: Tween(begin: Offset(0, fromTop ? -1 : 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  static void toast(String content, {ToastGravity gravity = ToastGravity.BOTTOM, Toast tLength = Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: tLength,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xffE7EAED),
      textColor: Color(0xff2F3033),
      fontSize: 16.0,
    );
  }

  static showCustomDialog(BuildContext context, {bool fromTop = false, required String body, String? title, bool tapToDismiss = true, bool expandHeight = false}) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      // barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => (tapToDismiss) ? Navigator.pop(context) : null,
            child: Align(
              alignment: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
              // alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Container(
                    // height: (expandHeight) ? 250 : 150,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(24),
                    // child: SizedBox.expand(child: FlutterLogo()),
                    child: Text(
                      body,
                      style: TextStyle(fontSize: 16),
                    ),
                    margin: EdgeInsets.only(bottom: 50, left: 12, right: 12, top: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, anim2, child) {
        return SlideTransition(
          // position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          //If you want to start with custom position, then all you can do is change begin: Offset(0, 1) to begin: Offset(0.2, 1)
          position: Tween(begin: Offset(0, fromTop ? -1 : 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  static showProgressDialog({String? title = 'Loading...', bool showBg = false}) {
    Get.generalDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        transitionBuilder: (context, anim, anim2, child) {
          return ScaleTransition(
            // set the zoom animation center
            alignment: Alignment.center,
            // animation controllers
            scale: anim,
            // will be executed sub-view movies
            child: child,
          );
        },
        pageBuilder: (context, __, ___) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Material(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(24),
                  // child: SizedBox.expand(child: FlutterLogo()),
                  child: LoadingProgressMultiColor(
                    title: title,
                    txtColor: Colors.white,
                    showBg: showBg,
                  ),
                ),
              ),
            ),
          );
        });
  }

  static hideProgressDialog() {
    Get.back();
  }
}
