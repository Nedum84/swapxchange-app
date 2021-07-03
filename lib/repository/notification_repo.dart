import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/notification_model.dart';
import 'package:swapxchange/ui/home/tabs/dashboard/register_notification.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/firebase_collections.dart';

class NotificationRepo {
  final String serverToken = Platform.isAndroid ? Constants.ANDROID_FCM_KEY : Constants.IOS_FCM_KEY;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  //Create notification collection instance
  static CollectionReference notificationCollection = FirebaseFirestore.instance.collection(FirebaseCollection.NOTIFICATION_COLLECTION);

  Future<NotificationModel?> sendNotification({required List<String> tokens, required NotificationModel model}) async {
    final Completer<NotificationModel?> completer = Completer<NotificationModel>();

    String url = 'https://fcm.googleapis.com/fcm/send';
    Dio dio = new Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "key=$serverToken";

    Map data = {};
    Map data2 = {
      'priority': model.priority,
      'user_id': model.userId,
      'date_created': model.dateCreated,
      'doc_id': model.docId,
      'is_read': model.isRead,
      'data': model.data!.toMap(),
      "content_available": true,
      "apns-priority": "5",
      // "notification": {"sound": ""},
    };
    // use "registration_ids" instead of "to" and send the push notification to multiple tokens
    data = {
      ...data2,
      // ...model.toMap(),
      "registration_ids": tokens,
      ...{
        'android': {
          'notification': {
            'channel_id': MESSAGE_CHANNEL_ID,
            'tag': "${model.data!.id}-${NotificationData.typeFromEnum(model.data!.type!)}",
          },
          'collapseKey': "${model.data!.id}-${NotificationData.typeFromEnum(model.data!.type!)}",
          'priority': 'high'
        }
      }
    };
    final data3 = {}..addAll(model.toMap())..addAll({"registration_ids": tokens});

    print(data2);

    await dio.post(url, data: data);

    return completer.future;
  }

  Map<String, dynamic> transform({required NotificationModel model}) {
    return <String, dynamic>{
      'notification': <String, dynamic>{
        'body': '${model.notification!.body}',
        'title': '${model.notification!.title}',
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '${model.data!.id}',
        'id_secondary': '${model.data!.idSecondary}',
        'type': '${model.data!.type}', //chat, product, call
      },
    };
  }

  static saveNotifications({required NotificationModel model, required List<AppUser> users}) async {
    //Send to all the users
    users.forEach((element) async {
      final data = {
        ...model.toMap(),
        "user_id": element.userId,
        "date_created": DateTime.now(),
      };
      notificationCollection.doc().set(data);
    });
  }

  //Get All user unread messages
  static Stream<QuerySnapshot> getMyNotifications({required int myId}) {
    return notificationCollection
        .where(FirebaseCollection.USER_ID, isEqualTo: myId)
        // .where(
        //   FirebaseCollection.IS_READ,
        //   isEqualTo: false,
        // )
        .snapshots();
  }

  //Mark as read/opened
  static void markAsRead({required String docId}) async {
    notificationCollection.doc(docId).update({
      FirebaseCollection.IS_READ: true,
    });
  }
}
