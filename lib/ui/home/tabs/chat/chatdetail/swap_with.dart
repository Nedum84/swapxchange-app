import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/repository/repo_product_chats.dart';
import 'package:swapxchange/ui/home/product/addproduct/add_product.dart';
import 'package:swapxchange/ui/home/product/exchange_options/swap_suggestion.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class SwapWith extends StatefulWidget {
  SwapWith({this.suggestedProduct, this.productPoster, this.gotoChat = true, this.productChatFn});
  AppUser? productPoster;
  Product? suggestedProduct;
  bool? gotoChat;
  Function(ProductChats productChats)? productChatFn;

  @override
  _SwapWithState createState() => _SwapWithState();
}

class _SwapWithState extends State<SwapWith> {
  PageController controller = PageController();

  Product? myProduct;
  late AppUser currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserController.to.user!;
  }

  _suggestSwap() {
    AlertUtils.confirm(
      'Do you want to swap your ${myProduct!.productName} with ${widget.suggestedProduct!.productName}',
      title: 'Confirm',
      positiveBtnText: 'YES',
      okCallBack: () async {
        ProductChats productChats = ProductChats(
          productId: widget.suggestedProduct!.productId,
          senderId: currentUser.userId,
          receiverId: widget.suggestedProduct!.userId,
          offerProductId: myProduct!.productId,
          chatStatus: SwapStatus.OPEN,
        );

        final addOrEdit = await RepoProductChats.createOne(productChats: productChats);
        if (addOrEdit != null) {
          //--> Add Swap suggestion to DB
          addSwapSuggestionToChatMessage(pChat: addOrEdit);
          //--> Close bottom shet
          Navigator.pop(context);
          if (!widget.gotoChat!)
            widget.productChatFn!(addOrEdit);
          else
            Get.to(() => ChatDetail(receiver: widget.productPoster!));
        } else {
          AlertUtils.toast('Chat initialization failed. Try again later');
        }
      },
    );
  }

  addSwapSuggestionToChatMessage({required ProductChats pChat}) {
    final p = widget.suggestedProduct;
    final offerP = myProduct;
    ChatMessage chatMsg = ChatMessage(
      receiverId: p!.userId,
      type: ChatMessageType.PRODUCT_CHAT,
      productChatId: pChat.productChatId,
      message: "${p.productId}@@${p.productName}@@${p.images!.first.imagePath}"
          " @@@ ${offerP!.productId}@@${offerP.productName}@@${offerP.images!.first.imagePath}", //Real time update
    );
    ChatDetailState.addMessageToDb(chatMsg);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: 260,
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            chooseProducts(),
            confirmSwap(),
          ],
        ),
      ),
    );
  }

  Widget chooseProducts() {
    return Column(
      children: [
        ListTile(
          trailing: CircleAvatar(
            backgroundColor: Colors.blueGrey.withOpacity(.1),
            radius: 16,
            child: IconButton(
              iconSize: 14,
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
          ),
          title: Text(
            'Choose your offer to swap',
            style: StyleNormal.copyWith(fontSize: 18),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Product>?>(
            future: RepoProduct.findByUserId(
              userId: currentUser.userId!,
              filters: Product.statusFromEnum(ProductStatus.ACTIVE_PRODUCT_STATUS),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: LoadingProgressMultiColor());
              }

              List<Product>? myProducts = snapshot.data;
              return ListView.builder(
                itemCount: (myProducts == null || myProducts.length == 0) ? 1 : myProducts.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (build, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: (myProducts != null && index < myProducts.length)
                        ? InkWell(
                            onTap: () {
                              setState(() => myProduct = myProducts[index]);
                              controller.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                            },
                            child: Container(
                              width: 105,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    child: CachedImage(
                                      myProducts[index].images!.first.imagePath!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      radius: 6,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    myProducts[index].productName!,
                                    style: StyleNormal.copyWith(fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          )
                        : AddNewOffer(
                            onClick: () {
                              final addCont = AddProductController.to;
                              if (addCont.product == null) {
                                addCont.setEditing(false);
                                addCont.create();
                              }
                              Get.back();
                              Get.to(() => AddProduct());
                            },
                          ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget confirmSwap() {
    return Column(
      children: [
        ListTile(
          trailing: CircleAvatar(
            backgroundColor: Colors.blueGrey.withOpacity(.1),
            radius: 16,
            child: IconButton(
              iconSize: 14,
              onPressed: () => controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut),
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.grey,
              ),
            ),
          ),
          title: Text(
            'Confirm swap suggestion',
            style: StyleNormal.copyWith(fontSize: 18),
          ),
        ),
        if (myProduct != null)
          Expanded(
            child: SwapSuggestion(
              myProduct: myProduct!,
              suggestedProduct: widget.suggestedProduct!,
            ),
          ),
        ButtonSmall(
          onClick: _suggestSwap,
          text: "Suggest swap",
          py: 8,
          px: 16,
          textColor: Colors.white,
          bgColor: KColors.PRIMARY,
        ),
      ],
    );
  }
}

class AddNewOffer extends StatelessWidget {
  final Function() onClick;

  const AddNewOffer({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                  color: KColors.TEXT_COLOR_DARK.withOpacity(.1),
                ),
              ),
              child: Icon(
                Icons.add_a_photo,
                size: 40,
                color: KColors.TEXT_COLOR_DARK.withOpacity(.1),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Add new offer',
              style: TextStyle(color: Colors.black, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
