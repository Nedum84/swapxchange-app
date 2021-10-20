import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/repository/repo_product_chats.dart';
import 'package:swapxchange/repository/repo_product_views.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/back_btn.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/call_chat_item.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/image_carousel.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/interest_and_swap_button.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/mapview.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/report_product.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/save_btn.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/call_utilities.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/permissions.dart';
import 'package:swapxchange/utils/strings.dart';
import 'package:swapxchange/utils/styles.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({Key? key, required this.product}) : super(key: key);

  _getPoster({gotoCall = false}) async {
    final AppUser currentUser = UserController.to.user!;
    if (product.userId == currentUser.userId) {
      // ... open exchange options
    } else {
      final poster = await UserController.to.getUser(userId: product.userId);
      if (poster == null) {
      } else {
        if (gotoCall) {
          final isPermGranted = await Permissions.cameraAndMicrophonePermissionsGranted();
          if (isPermGranted)
            CallUtils.dial(
              from: currentUser,
              to: poster,
              useVideo: false,
            );
        } else {
          final getRecent = await RepoProductChats.findRecentBwTwoUsers(secondUserId: product.userId!);
          if (getRecent == null || getRecent.productId != product.productId) {
            ProductChats productChats = ProductChats(
              productId: product.productId,
              senderId: currentUser.userId,
              receiverId: product.userId,
              chatStatus: SwapStatus.OPEN,
            );
            final createOne = await RepoProductChats.createOne(productChats: productChats);
            //--> Add swap suggestion to the database
            addSwapSuggestionToChatMessage(pChat: createOne!, poster: poster);
            Get.to(() => ChatDetail(receiver: poster));
          } else {
            //--> Update swap suggestion in the database
            // addSwapSuggestionToChatMessage(pChat: getRecent, poster: poster);
            Get.to(() => ChatDetail(receiver: poster));
          }
        }
      }
    }
  }

  addSwapSuggestionToChatMessage({required AppUser poster, required ProductChats pChat}) {
    ChatMessage chatMsg = ChatMessage(
      receiverId: poster.userId,
      type: ChatMessageType.PRODUCT_CHAT,
      productChatId: pChat.productChatId,
      message: "${product.productId}@@${product.productName}@@${product.images!.first.imagePath} @@@ ${pChat.offerProductId}", //Real time update
    );
    ChatDetailState.addMessageToDb(chatMsg);
  }

  _addProductView() {
    RepoProductViews.addProductView(productId: product.productId!);
  }

  @override
  Widget build(BuildContext context) {
    //Product no of views
    Future.delayed(Duration(milliseconds: 500), () {
      _addProductView();
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  ImageCarousel(imageProducts: product.images!),
                  Container(
                    padding: EdgeInsets.all(Constants.PADDING),
                    transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${product.productName}'.toUpperCase(),
                              style: H2Style.copyWith(),
                            ),
                            Spacer(),
                            Text(
                              '₦${Helpers.formatMoney(cash: product.price!)}',
                              style: TextStyle(
                                color: KColors.PRIMARY,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xffCD4F4E).withOpacity(.8),
                              size: 18,
                            ),
                            Text(
                              '${product.userAddress} • ${Helpers.formatDistance(distance: product.distance!)}',
                              style: StyleCategorySubTitle,
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        MapView(product: product),
                        SizedBox(height: 16),
                        if (product.userId != UserController.to.user!.userId)
                          Column(
                            children: [
                              CallChatItem(
                                imgPath: 'images/icon-call.png',
                                title: 'call for free',
                                onClick: () => _getPoster(gotoCall: true),
                              ),
                              SizedBox(height: 24),
                              CallChatItem(
                                imgPath: 'images/icon-chat.png',
                                title: 'start chat',
                                onClick: () => _getPoster(gotoCall: false),
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        Text('CATEGORY', style: H3Style),
                        SizedBox(height: 8),
                        FutureBuilder(
                          future: Future.wait([
                            CategoryController.to.fetchById(catId: product.category!),
                            SubCategoryController.to.fetchById(subCatId: product.subCategory!),
                          ]),
                          builder: (context, snapshots) {
                            if (!snapshots.hasData) return Container();

                            final data = snapshots.data! as List;
                            final cat = data[0] as Category;
                            final subCat = data[1] as SubCategory;
                            return Text('${cat.categoryName} • ${subCat.subCategoryName}', style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_DARK.withOpacity(.5)));
                          },
                        ),
                        SizedBox(height: 24),
                        Text('DESCRIPTION', style: H3Style),
                        SizedBox(height: 8),
                        Text(lorem.substring(0, 100), style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_DARK.withOpacity(.5))),
                        SizedBox(height: 24),
                        Text('POSTED BY', style: H3Style),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${product.user!.name} on ${Helpers.formatDate(product.createdAt!)}', style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_DARK.withOpacity(.5))),
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye, size: 16, color: KColors.TEXT_COLOR_LIGHT2),
                                Text("${product.noOfViews}", style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_LIGHT2)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Text('USER\'S INTEREST', style: H3Style),
                        SizedBox(height: 8),
                        InterestAndSwapButton(product: product),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ButtonOutline2(
                                title: 'Share product',
                                onClick: () => Share.share(Constants.SHARE_CONTENT, subject: 'Share via'),
                              ),
                            ),
                            SizedBox(width: 8),
                            if (product.userId != UserController.to.user!.userId)
                              Expanded(
                                flex: 1,
                                child: ReportProduct(product: product),
                              ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            ProductDetailBackBtn(),
            if (product.userId != UserController.to.user!.userId!) SaveBtn(product: product),
          ],
        ),
      ),
    );
  }
}
