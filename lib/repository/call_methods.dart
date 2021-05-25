import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swapxchange/models/call.dart';
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
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
