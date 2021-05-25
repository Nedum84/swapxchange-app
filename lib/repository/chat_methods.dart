import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/utils/firebase_collections.dart';

class ChatMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _messageCollection = _firestore.collection(FirebaseCollection.CHATS_COLLECTION);
  final CollectionReference _usersCollection = _firestore.collection(FirebaseCollection.USERS_COLLECTION);

  Future<void> addMessageToDb(ChatMessage chatMessage) {
    return _messageCollection.add(chatMessage.toMap());
  }

  //Mine
  Stream<QuerySnapshot> fetchChatContacts({required String userId}) {
    return _messageCollection
        .where(FirebaseCollection.SENDER_FIELD, isEqualTo: userId)
        // .orderBy(TIMESTAMP_FIELD, descending: true)
        .snapshots();
  }

  //Yours
  Stream<QuerySnapshot> fetchChatContacts2({required String userId}) {
    return _messageCollection.where(FirebaseCollection.RECEIVER_FIELD, whereIn: [
      userId,
    ]) //whereNotIn
        // .orderBy(TIMESTAMP_FIELD, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchChatContacts3({required String chatId}) => _messageCollection.where(FirebaseCollection.CHAT_ID, isEqualTo: chatId).snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({required String chatId}) {
    return _messageCollection.where(FirebaseCollection.CHAT_ID, whereIn: [chatId]).orderBy(FirebaseCollection.TIMESTAMP_FIELD, descending: true).limit(1).snapshots();
  }
}
