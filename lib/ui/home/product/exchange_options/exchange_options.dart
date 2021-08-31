import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/repository/repo_product_chats.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

import 'swap_suggestion.dart';

class ExchangeOptions extends StatefulWidget {
  ExchangeOptions({required this.myProduct});

  final Product myProduct;

  @override
  _ExchangeOptionsState createState() => _ExchangeOptionsState();
}

class _ExchangeOptionsState extends State<ExchangeOptions> {
  Product? _myProduct;

  @override
  void initState() {
    super.initState();
    _myProduct = widget.myProduct;
  }

  _suggestSwap(Product? suggestedProduct) {
    AlertUtils.confirm(
      'Do you want to swap your ${_myProduct!.productName} with ${suggestedProduct!.productName}',
      title: 'Confirm',
      positiveBtnText: 'YES',
      okCallBack: () async {
        ProductChats productChats = ProductChats(
          productId: suggestedProduct.productId,
          senderId: _myProduct!.userId,
          receiverId: suggestedProduct.userId,
          offerProductId: _myProduct!.productId,
          chatStatus: SwapStatus.OPEN,
        );

        final addOrEdit = await RepoProductChats.createOne(productChats: productChats);
        if (addOrEdit == null) {
          AlertUtils.toast('Chat initialization failed. Try again later');
        } else {
          final poster = await UserController.to.getUser(userId: suggestedProduct.userId);
          if (poster == null) {
            AlertUtils.toast('User not be found');
          } else {
            Get.to(() => ChatDetail(receiver: poster));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEF2F4),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_sharp),
                onPressed: () => Navigator.pop(context),
                color: KColors.TEXT_COLOR_DARK,
              ),
              expandedHeight: 150.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "Exchange Options",
                  style: TextStyle(
                    color: KColors.TEXT_COLOR_DARK,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List<Product>?>(
            future: RepoProduct.findExchangeOptions(productId: _myProduct!.productId!),
            builder: (context, AsyncSnapshot<List<Product>?> snapshot) {
              if (!snapshot.hasData) return Center(child: LoadingProgressMultiColor());

              var products = snapshot.data;
              if (products!.isEmpty) {
                return Center(
                  child: Text(
                    'No exchange found',
                    style: StyleNormal.copyWith(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (build, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        children: [
                          SwapSuggestion(
                            myProduct: _myProduct!,
                            suggestedProduct: products[index],
                            openProduct: true,
                          ),
                          SizedBox(height: 10),
                          ButtonSmall(
                            text: 'Suggest swap',
                            py: 8,
                            bgColor: KColors.PRIMARY,
                            textColor: Colors.white.withOpacity(.8),
                            onClick: () => _suggestSwap(products[index]),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
