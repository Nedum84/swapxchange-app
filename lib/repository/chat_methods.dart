import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/utils/firebase_collections.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _messageCollection = _firestore.collection(FirebaseCollection.CHATS_COLLECTION);
final CollectionReference _usersCollection = _firestore.collection(FirebaseCollection.USERS_COLLECTION);

class ChatMethods {
  static Future<void> addMessageToDb(ChatMessage chatMessage) {
    return _messageCollection.add(chatMessage.toMap());
  }

  //Mine
  Stream<QuerySnapshot> fetchChatContacts({required String userId}) {
    return _messageCollection
        .where(FirebaseCollection.SENDER_FIELD, isEqualTo: userId)
        // .orderBy(TIMESTAMP_FIELD, descending: true)
        .snapshots();
  }

  //Fetch chats1 (where receiver = 1 and sender = 2)
  static Stream<QuerySnapshot> fetchChats1({required int user1, required int user2}) {
    return _messageCollection
        .where(FirebaseCollection.RECEIVER_FIELD, isEqualTo: user1)
        .where(FirebaseCollection.SENDER_FIELD, isEqualTo: user2)
        .orderBy(
          FirebaseCollection.TIMESTAMP_FIELD,
          descending: true,
        )
        .snapshots();
  }

  //Fetch chats1 (where sender = 1 and receiver = 2)
  static Stream<QuerySnapshot> fetchChats2({required int user1, required int user2}) {
    return _messageCollection
        .where(FirebaseCollection.SENDER_FIELD, isEqualTo: user1)
        .where(FirebaseCollection.RECEIVER_FIELD, isEqualTo: user2)
        .orderBy(
          FirebaseCollection.TIMESTAMP_FIELD,
          descending: true,
        )
        .snapshots();
  }

  static Stream<QuerySnapshot> fetchChatList1({required int userId}) => _messageCollection.where(FirebaseCollection.SENDER_FIELD, isEqualTo: userId).snapshots();
  static Stream<QuerySnapshot> fetchChatList2({required int userId}) => _messageCollection.where(FirebaseCollection.RECEIVER_FIELD, isEqualTo: userId).snapshots();

  //Mark user's message as read when opens the chat detail
  static markAsRead({required int secondUserId, required int myId}) async {
    final unread = await _messageCollection
        .where(
          FirebaseCollection.SENDER_FIELD,
          isEqualTo: secondUserId,
        )
        .where(
          FirebaseCollection.RECEIVER_FIELD,
          isEqualTo: myId,
        )
        .where(
          FirebaseCollection.IS_READ,
          isEqualTo: false,
        )
        .get();

    unread.docs.forEach((element) {
      _messageCollection.doc(element.id).update({
        FirebaseCollection.IS_READ: true,
      });
    });
  }

  //Get user unread messages
  static Stream<QuerySnapshot> getUnreadMessages({
    required int secondUserId,
    required int myId,
  }) =>
      _messageCollection
          .where(FirebaseCollection.SENDER_FIELD, isEqualTo: secondUserId)
          .where(FirebaseCollection.RECEIVER_FIELD, isEqualTo: myId)
          .where(
            FirebaseCollection.IS_READ,
            isEqualTo: false,
          )
          .snapshots();
}
