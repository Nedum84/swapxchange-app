import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/repository/repo_product_chats.dart';
import 'package:swapxchange/ui/home/product/addproduct/add_product.dart';
import 'package:swapxchange/ui/home/product/exchange_options/swap_suggestion.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/helpers.dart';

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
    AlertUtils.confirm('Do you want to swap your ${myProduct!.productName} with ${widget.suggestedProduct!.productName}', title: 'Confirm', positiveBtnText: 'YES', context: context, okCallBack: () {
      String chatId = Helpers.genRandString();
      ProductChats productChats = ProductChats(
        productId: widget.suggestedProduct!.productId,
        senderId: myProduct!.userId,
        receiverId: widget.suggestedProduct!.userId,
        offerProductId: myProduct!.productId,
        chatStatus: 'open',
      );

      RepoProductChats.createOne(productChats: productChats).then((productChats) {
        if (productChats != null) {
          Navigator.pop(context, productChats);
          if (!widget.gotoChat!)
            widget.productChatFn!(productChats);
          else
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetail(
                  receiver: widget.productPoster!,
                  // productChats: productChats,
                ),
              ),
            );
        } else {
          AlertUtils.toast(
            'Chat initialization failed. Try again later',
          );
        }
      }).catchError((error) {
        AlertUtils.toast(
          'Chat initialization failed. Try again later',
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: 260,
        padding: EdgeInsets.all(12.0),
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
            Container(
              child: Column(
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
                    title: Center(
                      child: Text(
                        'Choose your offer to swap',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Product>?>(
                      future: RepoProduct.findByUserId(userId: currentUser.userId!, filters: "3"),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        List<Product>? myProducts = snapshot.data;

                        return ListView.builder(
                            itemCount: (myProducts == null || myProducts.length == 0) ? 1 : myProducts.length + 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (build, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(),
                                child: (myProducts != null && index < myProducts.length)
                                    ? GestureDetector(
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
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  radius: 6,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                myProducts[index].productName!,
                                                style: TextStyle(color: Colors.black, fontSize: 13),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
                                        },
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
                                                  Icons.enhance_photo_translate_sharp,
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
                                      ),
                              );
                            });
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
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
                    title: Center(
                      child: Text(
                        'Confirm swap suggestion',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SwapSuggestion(
                      myProduct: myProduct!,
                      suggestedProduct: widget.suggestedProduct!,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _suggestSwap();
                    },
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: KColors.SECONDARY,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 2, color: KColors.PRIMARY),
                      ),
                      child: Text(
                        'Suggest swap',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
