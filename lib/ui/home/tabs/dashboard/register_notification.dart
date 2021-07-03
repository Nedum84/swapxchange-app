import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/notification_model.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/utils/colors.dart';

FirebaseMessaging _messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const MESSAGE_CHANNEL_ID = 'Xchange-Messaging';
const MESSAGE_CHANNEL_NAME = 'SwapXchange Instant Messaging';
const MESSAGE_CHANNEL_DESCRIPTION = 'For real time Messaging';
AndroidNotificationChannel andChannel = AndroidNotificationChannel(MESSAGE_CHANNEL_ID, MESSAGE_CHANNEL_NAME, MESSAGE_CHANNEL_DESCRIPTION);

void updateNotificationToken() {
  _messaging.getToken().then((token) {
    final cUser = UserController.to.user;
    if (cUser != null) {
      if (cUser.deviceToken != token) {
        cUser.deviceToken = token;
        AuthRepo().updateUserDetails(
          appUser: cUser,
          onSuccess: (appUser) {},
          onError: (er) => print("$er"),
        );
      }
    }
  });
}

void registerNotification() async {
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
        andChannel,
      );
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_logo');

  /// Note: permissions aren't requested here just to demonstrate that can be later
  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
    if (payload != null) {
      getNotificationData(payload);
    }
  });

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await _messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // initial message that appears for every msg...
  _messaging.getInitialMessage().then((RemoteMessage? message) {
    print('New Initial message received!!! ----- 9000000');
    if (message != null) {
      showLocalNotification(message);
    }
  });

  //When app is active
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('New on message received!!!');

    try {
      final notificationData = NotificationData.fromMap(message.data);
      if (notificationData.type == NotificationType.CHAT) return;
      showLocalNotification(message);
    } catch (e) {
      print(e);
      showLocalNotification(message);
    }
  });
  // A new onMessageOpenedApp event was published!
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    showLocalNotification(message);
  });
}

//Background/Foreground
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.data}  ${message.notification}');
  showLocalNotification(message);
}

void getNotificationData(String payload) {
  try {
    final notificationData = NotificationData.fromJson(payload);
    final model = NotificationModel(
      notification: PushNotification(
        body: "",
        title: "",
      ),
      data: notificationData,
    );
    if (model.data != null) {
      routeNotification(model);
    }
  } catch (e) {
    print('Error converting notification: ');
    print(e);
  }
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

void showLocalNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android!;
  final notificationData = NotificationData.fromMap(message.data);
  final isCall = notificationData.type == NotificationType.CALL;
  final isProduct = notificationData.type != NotificationType.PRODUCT;
  final groupKey = notificationData.id.toString();

  if (notificationData.id != null) {
    flutterLocalNotificationsPlugin.show(
      // notification.hashCode,
      int.tryParse(groupKey) ?? notification.hashCode,
      notificationData.title ?? "New Notification",
      notificationData.body ?? "Click to view",
      NotificationDetails(
        android: AndroidNotificationDetails(
          andChannel.id, andChannel.name, andChannel.description,
          enableVibration: isCall ? true : false,
          enableLights: isCall ? true : false,
          // onlyAlertOnce: true,
          ledOnMs: 1000,
          ledOffMs: 500,
          // color: KColors.PRIMARY,
          ledColor: KColors.PRIMARY,
          importance: isCall ? Importance.max : Importance.defaultImportance,
          priority: isCall ? Priority.high : Priority.defaultPriority,
          sound: RawResourceAndroidNotificationSound('notification_tone'),
          // playSound: isCall ? true : false,
          timeoutAfter: isProduct ? 36000000 : 300000, //1hr, 5mins
          // icon: 'app_logo',
        ),
      ),
      payload: notificationData.toJson(),
    );
  }
}
