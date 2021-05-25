import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/repository/repo_product_chats.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';

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
    AlertUtils.confirm('Do you want to swap your ${_myProduct!.productName} with ${suggestedProduct!.productName}', title: 'Confirm', positiveBtnText: 'YES', context: context, okCallBack: () {
      ProductChats productChats = ProductChats(
        productId: suggestedProduct.productId,
        senderId: _myProduct!.userId,
        receiverId: suggestedProduct.userId,
        offerProductId: _myProduct!.productId,
        chatStatus: 'open',
      );

      RepoProductChats.createOne(productChats: productChats).then((productChats) {
        if (productChats != null) {
          AuthRepo.findByUserId(userId: suggestedProduct.userId).then((appUser) {
            if (appUser != null) {
              Get.to(() => ChatDetail(receiver: appUser));
            } else {
              AlertUtils.toast(
                'User not be found',
              );
            }
          });
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
                    // fontSize: 16.0,
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
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

              var products = snapshot.data;
              if (products!.isEmpty) {
                return Center(child: Text('No exchange found'));
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
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              _suggestSwap(products[index]);
                            },
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: KColors.SECONDARY,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                border: Border.all(
                                  width: 2,
                                  color: KColors.SECONDARY,
                                ),
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
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
