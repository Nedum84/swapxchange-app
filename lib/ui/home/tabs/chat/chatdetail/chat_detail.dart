import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/enum/online_status.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/chat_methods.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/repository/repo_product_chats.dart';
import 'package:swapxchange/repository/storage_methods.dart';
import 'package:swapxchange/ui/home/callscreens/pickup_layout.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/swap_with.dart';
import 'package:swapxchange/ui/home/tabs/profile/profile.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/choose_image_from.dart';
import 'package:swapxchange/ui/widgets/view_image.dart';
import 'package:swapxchange/utils/call_utilities.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/firebase_collections.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/permissions.dart';

class ChatDetail extends StatefulWidget {
  final AppUser receiver;

  ChatDetail({
    required this.receiver,
  });

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final RepoStorage _storageMethods = RepoStorage();

  final ChatMethods _chatMethods = ChatMethods();

  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  ScrollController _listScrollController = ScrollController();

  late AppUser sender;
  late AppUser _receiver;

  late ProductChats _productChats;
  Product? _product;
  late String _productImageUrl;

  Product? _offerProduct;
  String? _offerProductImageUrl;

  AppUser? _currentUser;
  bool isWriting = false;
  bool showEmojiPicker = false;

  @override
  void initState() {
    super.initState();

    _receiver = widget.receiver;
    _currentUser = UserController.to.user;

    _init();
  }

  _init() async {
    final getProductChat = await RepoProductChats.findRecentBwTwoUsers(secondUserId: _receiver.userId!);
    if (getProductChat != null) setState(() => _productChats = getProductChat);

    final getProduct = await RepoProduct.getById(productId: _productChats.productId!);
    if (getProduct != null) setState(() => _product = getProduct);

    if (_productChats.offerProductId != 0) return;
    final getOffer = await RepoProduct.getById(productId: _productChats.offerProductId!);
    if (getOffer != null) setState(() => _offerProduct = getOffer);
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() => setState(() => showEmojiPicker = false);

  showEmojiContainer() => setState(() => showEmojiPicker = true);

  _findExchangeOptions() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (build) {
          return SwapWith(
            suggestedProduct: _product,
            productPoster: _receiver,
            gotoChat: false,
            productChatFn: (pChat) {
              setState(() {
                _productChats = pChat;
                _init();
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showEmojiPicker) {
          hideEmojiContainer();
          return false;
        } else {
          Navigator.pop(context, _productChats);
          return true;
        }
        ;
      },
      child: PickupLayout(
        scaffold: Scaffold(
          backgroundColor: Color(0xffEEF2F4),
          appBar: customAppBar(context),
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 4, left: 8, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 1.0, offset: Offset(0.0, 0.2))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _product?.productName ?? '',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            CachedImage(
                              _productImageUrl,
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                              radius: 12,
                              alt: ImagePlaceholder.QuestionMark,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.sync,
                        color: Colors.blueGrey.withOpacity(.5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            CachedImage(
                              _offerProduct!.images!.first.imagePath!,
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                              radius: 12,
                              alt: ImagePlaceholder.QuestionMark,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                _offerProduct?.productName ?? '',
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    messageList(),
                    Visibility(
                      visible: (_product == null || _productChats.offerProductId != 0 || _product!.userId == _currentUser!.userId) ? false : true,
                      child: Positioned(
                          bottom: 6,
                          left: 6,
                          child: GestureDetector(
                            onTap: () {
                              _findExchangeOptions();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: KColors.SECONDARY),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 12,
                                    child: Icon(
                                      Icons.sync_outlined,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Text(
                                    ' suggest',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              chatControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(FirebaseCollection.CHATS_COLLECTION).where(FirebaseCollection.CHAT_ID, isEqualTo: _productChats.id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "You have not started any chat with this user.",
              ),
            );
          }

          final chatMessages = snapshot.data!.docs.reversed;
          List<ChatMessage> chatMessage = [];
          for (var message in chatMessages) {
            ChatMessage msg = ChatMessage.fromMap(message.data());
            chatMessage.add(msg);
          }
          chatMessage.sort((a, b) => b.timestamp!.compareTo(a.timestamp!)); //desc

          return ListView.builder(
            padding: EdgeInsets.all(8),
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return chatMessageItem(chatMessage[index]);
            },
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget chatMessageItem(ChatMessage chatMessage) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        alignment: chatMessage.senderId != _receiver.userId ? Alignment.centerRight : Alignment.centerLeft,
        child: chatMessage.senderId != _receiver.userId ? senderLayout(chatMessage) : receiverLayout(chatMessage),
      ),
    );
  }

  Widget senderLayout(ChatMessage message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: BoxDecoration(
          color: KColors.SECONDARY.withOpacity(.3),
          border: Border.all(color: Colors.blueGrey.withOpacity(.2), width: 1),
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            getMessage(message),
            SizedBox(
              height: 2,
            ),
            Text(
              '12:21AM',
              style: TextStyle(fontSize: 10, color: Colors.black26, fontStyle: FontStyle.italic),
            )
          ],
        ));
  }

  getMessage(ChatMessage message) {
    return message.type == ChatMessageType.TEXT
        ? Text(
            message.message!,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          )
        : message.photoUrl != null && message.type == ChatMessageType.IMAGE
            ? GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewImage(
                      curStep: 0,
                      imageProducts: [ProductImage(imagePath: message.photoUrl, productId: 0, id: 0, idx: 0)],
                    ),
                  ),
                ),
                child: CachedImage(
                  message.photoUrl!,
                  height: 250,
                  width: 250,
                  radius: 10,
                ),
              )
            : Container();
  }

  Widget receiverLayout(ChatMessage message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: BoxDecoration(
          color: Colors.white70.withOpacity(.4),
          border: Border.all(color: Colors.blueGrey.withOpacity(.2), width: 1),
          borderRadius: BorderRadius.only(
            bottomRight: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getMessage(message),
            SizedBox(
              height: 2,
            ),
            Text(
              '12:21AM',
              style: TextStyle(fontSize: 10, color: Colors.black26, fontStyle: FontStyle.italic),
            )
          ],
        ));
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    _showFileChooser() {
      hideKeyboard();

      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ChooseImageFrom(
            imageSource: (source) => pickImage(source: source),
          );
        },
      );
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 4, bottom: 4, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: KColors.WHITE_GREY,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => _showFileChooser(),
                  icon: Icon(Icons.add_a_photo_sharp, color: Colors.blueGrey.withOpacity(.8)),
                ),
          SizedBox(
            width: 5,
          ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(boxShadow: [Constants.SHADOW], shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 18,
                    ),
                    onPressed: () => sendMessage(type: ChatMessageType.TEXT),
                  ))
              : Container()
        ],
      ),
    );
  }

  sendMessage({required String type, imagePath}) {
    var text = textFieldController.text;
    ChatMessage _message = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      receiverId: _receiver.userId,
      senderId: sender.userId,
      timestamp: Timestamp.now().microsecondsSinceEpoch,
      type: type,
    );
    if (type == ChatMessageType.TEXT) {
      _message.message = text;
    } else if (type == ChatMessageType.IMAGE) {
      _message.photoUrl = imagePath;
    } else if (type == ChatMessageType.PRODUCT_CHAT) {
      // ...
    }

    setState(() => isWriting = false);
    textFieldController.text = "";
    hideKeyboard();
    _chatMethods.addMessageToDb(_message);
  }

  void pickImage({required ImageSource source}) async {
    File? selectedImage = await Helpers.pickImage(source: source);
    if (selectedImage != null) {
      final String? imgPath = await _storageMethods.uploadImageToStorage(selectedImage);
      if (imgPath != "") {
        sendMessage(type: ChatMessageType.IMAGE, imagePath: imgPath);
      }
    }
  }

  AppBar customAppBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.blueGrey,
        ),
        onPressed: () {
          Navigator.pop(context, _productChats);
        },
      ),
      centerTitle: false,
      title: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(
                    // appUser: _receiver,
                    ))),
        child: Row(
          children: [
            CachedImage(
              _receiver.profilePhoto!,
              radius: 40,
              isRound: true,
              alt: ImagePlaceholder.User,
            ),
            SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiver.name!,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                ),
                UserOnlineStatus(
                  appUser: _receiver,
                ),
                // Text('online', style: TextStyle(color: Colors.green),),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
            color: Colors.blueGrey,
          ),
          onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted()
              ? CallUtils.dial(
                  from: sender,
                  to: widget.receiver,
                  useVideo: true,
                )
              : {},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
            color: Colors.blueGrey,
          ),
          onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted()
              ? CallUtils.dial(
                  from: sender,
                  to: widget.receiver,
                  useVideo: false,
                )
              : {},
        )
      ],
    );
  }
}

// class ModalTile extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Function onTap;
//
//   const ModalTile({
//     @required this.title,
//     @required this.subtitle,
//     @required this.icon,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       child: CustomTile(
//         mini: false,
//         onTap: onTap,
//         leading: Container(
//           margin: EdgeInsets.only(right: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: kColorBlue,
//           ),
//           padding: EdgeInsets.all(10),
//           child: Icon(
//             icon,
//             color: kColorAsh,
//             size: 38,
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(
//             color: kColorAsh,
//             fontSize: 14,
//           ),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     );
//   }
// }

class UserOnlineStatus extends StatelessWidget {
  final AppUser appUser;

  UserOnlineStatus({required this.appUser});

  getColor(String onlineStatus) {
    if (onlineStatus == EnumToString.convertToString(OnlineStatus.ONLINE).toLowerCase()) {
      return Colors.green;
    } else if (onlineStatus == EnumToString.convertToString(OnlineStatus.OFFLINE).toLowerCase()) {
      return Colors.grey;
    } else if (onlineStatus == EnumToString.convertToString(OnlineStatus.AWAY).toLowerCase()) {
      return Colors.orange;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: AuthRepo.getUserStream(uid: appUser.uid!),
      builder: (context, snapshot) {
        AppUser? user;

        if (!snapshot.hasData && snapshot.data == null) {
          return Container();
        }

        user = AppUser.fromMap(snapshot.data!.data()!);
        return Text(
          user.onlineStatus ?? "offline",
          style: TextStyle(color: getColor(user.onlineStatus!), fontSize: 12),
        );
      },
    );
  }
}
