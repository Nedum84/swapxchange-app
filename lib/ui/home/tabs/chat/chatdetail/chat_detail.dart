import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapxchange/controllers/my_product_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/models/notification_model.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/notification_repo.dart';
import 'package:swapxchange/repository/repo_chats.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/repository/repo_product_chats.dart';
import 'package:swapxchange/repository/storage_methods.dart';
import 'package:swapxchange/ui/home/callscreens/pickup_layout.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/sections/chat_appbar.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/sections/chat_message_list.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/sections/close_deal.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/sections/swap_suggest_btn.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/sections/topbar_swap_suggestion.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/swap_with.dart';
import 'package:swapxchange/ui/widgets/choose_image_from.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/styles.dart';

class ChatDetail extends StatefulWidget {
  final AppUser receiver;

  ChatDetail({
    required this.receiver,
  });

  @override
  ChatDetailState createState() => ChatDetailState();
}

class ChatDetailState extends State<ChatDetail> {
  final RepoStorage _storageMethods = RepoStorage();

  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  late AppUser _receiver;

  ProductChats? _productChats;
  Product? _product;

  Product? _offerProduct;

  AppUser? _currentUser;
  bool isWriting = false;
  bool showEmojiPicker = false;
  bool showActiveProduct = false;
  bool showSwapBtn = false;
  //Text to show for closed deal/ recent deal
  String? closeDealText;
  bool showRejectDealBtn = false;

  @override
  void initState() {
    super.initState();

    _receiver = widget.receiver;
    _currentUser = UserController.to.user;

    _init();
    _markAsRead();
  }

  _init() async {
    final getProductChat = await RepoProductChats.findRecentBwTwoUsers(secondUserId: _receiver.userId!);
    if (getProductChat != null) setState(() => _productChats = getProductChat);
    if (_productChats == null) return;

    final getProduct = await RepoProduct.getById(productId: _productChats!.productId!);
    if (getProduct != null) setState(() => _product = getProduct);

    if (_productChats?.offerProductId != 0) {
      final getOffer = await RepoProduct.getById(productId: _productChats!.offerProductId!);
      if (getOffer != null) setState(() => _offerProduct = getOffer);
    }
    //--> products to swap at the top
    if (_productChats!.chatStatus == SwapStatus.OPEN) {
      setState(() => showActiveProduct = true);
    } else {
      setState(() => showActiveProduct = false);
    }

    //--> Show swap btn
    if (_productChats!.chatStatus == SwapStatus.OPEN && (_currentUser!.userId == _product!.userId && _product == null || _currentUser!.userId != _product!.userId && _offerProduct == null)) {
      setState(() => showSwapBtn = true);
    } else {
      setState(() => showSwapBtn = false);
    }

    //--> Close Previous Deal Btn
    if (_productChats!.productId != 0 && _productChats!.offerProductId != 0) {
      //Still open deal
      if (_productChats!.chatStatus == SwapStatus.OPEN) {
        showRejectDealBtn = false;
        //I sent the product
        if (_productChats!.senderId == _currentUser!.userId) {
          //The user have not closed the deal
          if (_productChats!.senderClosedDeal == 0 && _productChats!.receiverClosedDeal == 0) {
            //Show close deal btn
            closeDealText = "Close this deal";
          } else if (_productChats!.receiverClosedDeal != 0) {
            //Show accept to close deal btn
            closeDealText = "Accept deal";
            showRejectDealBtn = true;
          } else if (_productChats!.senderClosedDeal != 0) {
            //Show close deal btn
            closeDealText = "Waiting for approval from ${_receiver.name}";
          }
        } else {
          // not me
          //The user(sender) have not closed the deal
          if (_productChats!.senderClosedDeal == 0 && _productChats!.receiverClosedDeal == 0) {
            //Show close deal btn
            closeDealText = "Close this deal";
          } else if (_productChats!.senderClosedDeal != 0) {
            //Show accept to close deal btn
            closeDealText = "Accept deal";
            showRejectDealBtn = true;
          } else if (_productChats!.receiverClosedDeal != 0) {
            //Show close deal btn
            closeDealText = "Waiting for approval from ${_receiver.name}";
          }
        }
      } else if (_productChats!.chatStatus == SwapStatus.DECLINED) {
        //Toast alert that the previous deal was declined
        // AlertUtils.showCustomDialog(body: 'Your previous deal with this user was declined');
        closeDealText = null;
      } else if (_productChats!.chatStatus == SwapStatus.EXCHANGED) {
        closeDealText = null;
        //Toast alert that the previous deal was closed/exchanged successfully
        // AlertUtils.showCustomDialog(body: 'Your previous deal with this user was closed/exchanged successfully');
      }
    } else {
      closeDealText = null;
    }
    setState(() {});
  }

  void onCloseDeal() async {
    //--> Close Previous Deal Btn
    if (_productChats!.productId != 0 && _productChats!.offerProductId != 0) {
      //Still open deal
      if (_productChats!.chatStatus == SwapStatus.OPEN) {
        AlertUtils.confirm(
          'Close this deal with ${_receiver.name}',
          title: 'Confirm!',
          positiveBtnText: 'CLOSE DEAL',
          okCallBack: () async {
            AlertUtils.showProgressDialog(title: null);
            final nPcChat = await RepoProductChats.findById(id: _productChats!.id!); //Move it up to avoid duplicate firebase msg send
            //I sent the product
            if (_productChats!.senderId == _currentUser!.userId) {
              nPcChat!.senderClosedDeal = 1;
              if (nPcChat.receiverClosedDeal == 1) {
                nPcChat.chatStatus = SwapStatus.EXCHANGED;
              }
              final update = await RepoProductChats.createOne(productChats: nPcChat);
              AlertUtils.hideProgressDialog();
              if (update != null) {
                if (update.chatStatus == SwapStatus.EXCHANGED) {
                  AlertUtils.alert('Your deal with ${_receiver.name} was successfully closed');
                  messageClosedDeal('Deal with this user was closed');
                  markProductsCompleted();
                }
                _init();
              }
            } else {
              //The user(sender) have not closed the deal
              nPcChat!.receiverClosedDeal = 1;
              if (nPcChat.senderClosedDeal == 1) {
                nPcChat.chatStatus = SwapStatus.EXCHANGED;
              }
              final update = await RepoProductChats.createOne(productChats: nPcChat);
              AlertUtils.hideProgressDialog();
              if (update != null) {
                if (update.chatStatus == SwapStatus.EXCHANGED) {
                  AlertUtils.alert('Your deal with ${_receiver.name} was successfully closed');
                  messageClosedDeal('Deal with this user was closed');
                  markProductsCompleted();
                }
                _init();
              }
            }
          },
        );
      }
    }
  }

  void markProductsCompleted() {
    RepoProduct.updateProduct(product: (_product!..productStatus = ProductStatus.COMPLETED_PRODUCT_STATUS));
    RepoProduct.updateProduct(product: (_offerProduct!..productStatus = ProductStatus.COMPLETED_PRODUCT_STATUS));
    MyProductController.to.fetchAll(reset: true);
  }

  void onDeclineDeal() async {
    AlertUtils.confirm(
      'Decline this deal from ${_receiver.name}',
      title: 'Confirm!',
      positiveBtnText: 'DECLINE',
      okCallBack: () async {
        final nPcChat = _productChats!..chatStatus = SwapStatus.DECLINED;

        AlertUtils.showProgressDialog(title: null);
        final update = await RepoProductChats.createOne(productChats: nPcChat);
        AlertUtils.hideProgressDialog();
        if (update != null) {
          if (update.chatStatus == SwapStatus.DECLINED) {
            AlertUtils.alert('You declined the deal with ${_receiver.name}');
            messageClosedDeal('Deal with this user was declined');
          }
          _init();
        }
      },
    );
  }

  void messageClosedDeal(String msg) {
    ChatMessage chatMsg = ChatMessage(
      receiverId: _receiver.userId,
      type: ChatMessageType.CLOSE_DEAL,
      message: msg, //Real time update
    );
    addMessageToDb(chatMsg);
  }

  void _markAsRead() {
    RepoChats.markAsRead(secondUserId: _receiver.userId!, myId: _currentUser!.userId!);
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() => setState(() => showEmojiPicker = false);

  showEmojiContainer() => setState(() => showEmojiPicker = true);

  _findExchangeOptions() {
    Get.bottomSheet(
      SwapWith(
        suggestedProduct: _product,
        productPoster: _receiver,
        gotoChat: false,
        productChatFn: (pChat) => _init(),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Color(0xffEEF2F4),
        appBar: chatAppBar(receiverUser: _receiver, currentUser: _currentUser!),
        body: Column(
          children: <Widget>[
            if (showActiveProduct)
              TopbarSwapSuggestion(
                product: _product,
                offerProduct: _offerProduct,
              ),
            Flexible(
              child: Stack(
                children: [
                  ChatMessageList(currentUser: _currentUser!, receiverUser: _receiver),
                  Visibility(
                    visible: showSwapBtn,
                    child: SwapSuggestBtn(
                      onClick: _findExchangeOptions,
                    ),
                  ),
                  if (closeDealText != null && !showSwapBtn)
                    CloseDealWidget(
                      onCloseDeal: onCloseDeal,
                      onDeclineDeal: onDeclineDeal,
                      closeDealText: closeDealText!,
                      showRejectDealBtn: showRejectDealBtn,
                    ),
                ],
              ),
            ),
            chatControls(),
          ],
        ),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() => isWriting = val);
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
                  style: StyleNormal.copyWith(
                    color: KColors.TEXT_COLOR_DARK,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Message ${_receiver.name!.split(" ")[0]}...",
                    hintStyle: StyleNormal.copyWith(
                      color: KColors.TEXT_COLOR_LIGHT,
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
                  icon: Icon(Icons.add_a_photo_sharp, color: KColors.TEXT_COLOR_DARK.withOpacity(.8)),
                ),
          SizedBox(width: 5),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KColors.PRIMARY,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 18,
                      color: Colors.white,
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
    ChatMessage _message = ChatMessage(receiverId: _receiver.userId, type: type);
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
    addMessageToDb(_message);
  }

  static addMessageToDb(ChatMessage message) {
    message.id = DateTime.now().microsecondsSinceEpoch.toString();
    message.senderId = UserController.to.user!.userId;
    message.timestamp = Timestamp.now().microsecondsSinceEpoch;
    RepoChats.addMessageToDb(message);
    sendNotification(message);
  }

  //Send PUSH Notification
  static sendNotification(ChatMessage message) async {
    final isProduct = message.type == ChatMessageType.PRODUCT_CHAT;
    AppUser currentUser = UserController.to.user!;
    AppUser? receiver = await UserController.to.getUser(userId: message.receiverId);
    if (receiver != null) {
      if (receiver.notification!.chat != 1) return;
      final notRepo = NotificationRepo();
      final model = NotificationModel(
        data: NotificationData(
          type: NotificationType.CHAT,
          id: message.senderId.toString(),
          idSecondary: message.receiverId.toString(),
          payload: message.toJson(),
          title: 'Message from ${currentUser.name}',
          body: !isProduct ? message.message : "Swap suggestion",
        ),
        notification: PushNotification(
          title: 'Message from ${currentUser.name}',
          body: !isProduct ? message.message : "Swap suggestion",
        ),
      );
      notRepo.sendNotification(tokens: [receiver.deviceToken!], model: model);
    }
  }

  void pickImage({required ImageSource source}) async {
    File? selectedImage = await Helpers.pickImage(source: source);
    if (selectedImage != null) {
      AlertUtils.showProgressDialog(title: null);
      final String? imgPath = await _storageMethods.uploadFile(selectedImage);
      AlertUtils.hideProgressDialog();
      if (imgPath != "") {
        sendMessage(type: ChatMessageType.IMAGE, imagePath: imgPath);
      }
    }
  }
}
