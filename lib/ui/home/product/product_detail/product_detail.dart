import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/back_btn.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/interest_and_swap_button.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/save_btn.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/strings.dart';
import 'package:swapxchange/utils/styles.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  _getPoster({gotoCall = false}) async {
    final poster = await AuthRepo.findByUserId(userId: product.userId);
    if (poster == null) {
    } else {
      if (gotoCall)
        Get.to(() => ChatDetail(receiver: poster));
      else
        Get.to(() => ChatDetail(receiver: poster));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'images/swapx.jpeg',
                      width: double.infinity,
                      height: Get.size.height / 3,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
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
                      SizedBox(height: 24),
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
                          return Text('${cat.categoryName} • ${subCat.subCategoryName}', style: StyleNormal);
                        },
                      ),
                      SizedBox(height: 24),
                      Text('DESCRIPTION', style: H3Style),
                      SizedBox(height: 8),
                      Text(lorem.substring(0, 100), style: StyleNormal),
                      SizedBox(height: 24),
                      Text('POSTED BY', style: H3Style),
                      SizedBox(height: 8),
                      Text('${product.user!.name} on ${Helpers.formatDate(product.createdAt!)}', style: StyleNormal),
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
                              onClick: () => null,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: ButtonOutline2(
                              titleColor: KColors.RED,
                              title: 'Report this',
                              onClick: () => null,
                            ),
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
          SaveBtn(),
        ],
      ),
    );
  }
}

class CallChatItem extends StatelessWidget {
  final String imgPath;
  final String title;
  final Function() onClick;

  const CallChatItem({Key? key, required this.imgPath, required this.title, required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Row(
        children: [
          Image.asset(
            imgPath,
            width: 30,
            height: 30,
          ),
          SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: KColors.PRIMARY,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
