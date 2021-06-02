import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/auth_repo.dart';
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
      // ... open exchange options
      Get.to(() => ExchangeOptions(myProduct: product), preventDuplicates: true);
    } else {
      final pPoster = await AuthRepo.findByUserId(userId: product.userId!);
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
                  title: '${cat.shortCatName()}',
                  size: 40,
                  textSize: 10,
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 8),
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
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 6),
                Image.asset(
                  'images/icon-swap.png',
                  width: 30,
                  height: 30,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
