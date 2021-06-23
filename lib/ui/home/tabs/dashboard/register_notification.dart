import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/notification_model.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';

FirebaseMessaging _messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void registerNotification() async {
  _messaging.getToken().then((token) {
    final cUser = UserController.to.user!;
    if (cUser.deviceToken != token) {
      cUser.deviceToken = token;
      AuthRepo().updateUserDetails(
        appUser: cUser,
        onSuccess: (appUser) {},
        onError: (er) => print("$er"),
      );
    }
  });

  AndroidNotificationChannel andChannel = AndroidNotificationChannel("channel id", "channel name", "channel description");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
        andChannel,
      );

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await _messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Set the background messaging handler early on, as a named top-level function
  _messaging.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print(message.toString());
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android!;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              andChannel.id,
              andChannel.name,
              andChannel.description,
              icon: 'launch_background',
            ),
          ));
    }
  });
  // A new onMessageOpenedApp event was published!
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');

    try {
      final model = NotificationModel(
        notification: PushNotification(
          body: message.notification!.body,
          title: message.notification!.title,
        ),
        data: NotificationData.fromMap(message.data),
      );
      if (model.data != null) {
        routeNotification(model);
      }
    } on Exception catch (e) {
      print(e);
    }
  });
}

void routeNotification(NotificationModel model) async {
  if (model.data!.type == NotificationType.CHAT) {
    final user = await UserController.to.getUser(userId: model.data!.id);
    if (user != null) {
      print(user.toJson());
      Get.to(() => ChatDetail(receiver: user));
    }
  } else if (model.data!.type == NotificationType.PRODUCT) {
    final product = await RepoProduct.getById(productId: int.parse(model.data!.id!));
    if (product != null) {
      Get.to(() => ProductDetail(product: product));
    }
  } else if (model.data!.type == NotificationType.CALL) {
    // Get.find<BottomMenuController>().onChangeMenu(BottomMenuItem.CHAT);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}
