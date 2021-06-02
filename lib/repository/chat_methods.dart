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

  Stream<QuerySnapshot> fetchChatContacts3({required String chatId}) => _messageCollection.where(FirebaseCollection.CHAT_ID, isEqualTo: chatId).snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({required String chatId}) {
    return _messageCollection
        .where(FirebaseCollection.CHAT_ID, whereIn: [chatId])
        .orderBy(
          FirebaseCollection.TIMESTAMP_FIELD,
          descending: true,
        )
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchLastMessageBetween2({
    required String senderId,
    required String receiverId,
  }) =>
      _messageCollection.where(FirebaseCollection.SENDER_FIELD, isEqualTo: senderId).where(FirebaseCollection.RECEIVER_FIELD, isEqualTo: receiverId).orderBy(FirebaseCollection.TIMESTAMP_FIELD, descending: true).snapshots();
}
