import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/call.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/utils/firebase_collections.dart';

class CallMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference callCollection = _firestore.collection(FirebaseCollection.CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({required String uid}) => callCollection.doc(uid).snapshots();

  Future<bool> makeCall({required Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({required Call call}) async {
    final getCall = await callCollection.doc(call.callerId).get();
    if (getCall.data() != null) {
      //there's an incoming call
      Call call = Call.fromMap(getCall.data()! as Map<String, dynamic>);
      if (call.isMissedCall! && call.callerId == UserController.to.user!.uid) {
        addMissedCall(posterUid: call.receiverId!);
      }
    }

    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  //Add Missed call to chat
  addMissedCall({required String posterUid}) async {
    final poster = await UserController.to.getUser(userId: posterUid);
    if (poster != null) {
      ChatMessage chatMsg = ChatMessage(
        receiverId: poster.userId,
        type: ChatMessageType.MISSED_CALL,
        message: "Missed Call", //Real time update
      );
      ChatDetailState.addMessageToDb(chatMsg);
    }
  }

  static Future<String?> generateCallToken({required String uid, required channelName}) async {
    final data = {"uid": uid, "channel_name": channelName};
    Response response = await ApiClient.request().post('/agora/generatetoken', data: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["data"]["token"];
    }

    return null;
  }

  void markMissedCall({required Call call, bool isMissedCall = false}) async {
    callCollection.doc(call.receiverId).update({'is_missed_call': isMissedCall});
    callCollection.doc(call.callerId).update({'is_missed_call': isMissedCall});
  }
}
