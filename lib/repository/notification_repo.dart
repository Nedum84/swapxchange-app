import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/notification_model.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/firebase_collections.dart';

class NotificationRepo {
  final String serverToken = Platform.isAndroid ? Constants.ANDROID_FCM_KEY : Constants.IOS_FCM_KEY;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<NotificationModel?> sendNotification({required List<String> tokens, required NotificationModel model}) async {
    final Completer<NotificationModel?> completer = Completer<NotificationModel>();

    String url = 'https://fcm.googleapis.com/fcm/send';
    Dio dio = new Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "key=$serverToken";

    Map data = {};
    if (tokens.length == 1) {
      data = {
        ...model.toMap(),
        ...{"to": tokens[0]},
        ...{
          'android': {
            'collapseKey': "${model.data!.id}-${NotificationData.typeFromEnum(model.data!.type!)}",
            'priority': 'high',
            'notification': {
              'tag': "${model.data!.id}-${NotificationData.typeFromEnum(model.data!.type!)}",
            }
          }
        }
      };
    } else {
      data = {
        ...model.toMap(),
        ...{"registration_ids": tokens},
        ...{
          'collapseKey': "${model.data!.id}-${NotificationData.typeFromEnum(model.data!.type!)}",
          // 'android': {
          //   'collapseKey': "${model.data!.id}-${NotificationData.typeFromEnum(model.data!.type!)}",
          //   'priority': 'high',
          //   'notification': {
          //     'tag': 'tag',
          //   }
          // }
        }
      };
    }
    // use "registration_ids" instead of "to" and send the push notification to multiple tokens
    final data2 = {}..addAll(model.toMap())..addAll({"registration_ids": tokens});

    print(data);

    await dio.post(url, data: data2);

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
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    //Create a batch
    CollectionReference notificationCollection = _firestore.collection(FirebaseCollection.NOTIFICATION_COLLECTION);

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
  static Stream<QuerySnapshot> getAllUnreadMessages({
    required int myId,
  }) {
    _messageCollection
        .where(FirebaseCollection.RECEIVER_FIELD, isEqualTo: myId)
        .where(
          FirebaseCollection.IS_READ,
          isEqualTo: false,
        )
        .snapshots();
  }
}
