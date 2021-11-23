import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/home/product/exchange_options/exchange_options.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/swap_with.dart';
import 'package:swapxchange/ui/home/tabs/home/top_deals.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';

class InterestAndSwapButton extends StatelessWidget {
  final Product product;

  const InterestAndSwapButton({Key? key, required this.product}) : super(key: key);

  _findExchangeOptions(BuildContext context) async {
    final AppUser currentUser = UserController.to.user!;
    if (product.userId == currentUser.userId) {
      if (product.productStatus == ProductStatus.BLOCKED_PRODUCT_STATUS || product.productStatus == ProductStatus.COMPLETED_PRODUCT_STATUS) {
        AlertUtils.alert('It seems you have either sold/exchanged this product or it has been altered. Contact support for more info.', title: 'Action not successful');
        return;
      }
      // ... open exchange options
      Get.to(() => ExchangeOptions(myProduct: product), preventDuplicates: true);
    } else {
      final pPoster = await UserController.to.getUser(userId: product.userId!);
      if (pPoster == null) {
        AlertUtils.toast('User not found');
        return;
      }

      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (build) {
          return SwapWith(
            suggestedProduct: product,
            productPoster: pPoster,
            gotoChat: true,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: product.suggestions!.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final cat = product.suggestions![index];
                return CategoryBtn(
                  imagePath: cat.categoryIcon ?? "",
                  title: '${cat.shortCatName()}',
                  size: 40,
                  textSize: 10,
                  padding: 8,
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 6),
            ),
          ),
          SizedBox(width: 12),
          InkWell(
            onTap: () => _findExchangeOptions(context),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  (product.userId != UserController.to.user!.userId) ? 'SWAP' : " OPTIONS",
                  style: TextStyle(
                    color: KColors.PRIMARY,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 6),
                Image.asset(
                  'images/icon-swap.png',
                  width: 20,
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
