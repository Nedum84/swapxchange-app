import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/back_btn.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/interest_and_swap_button.dart';
import 'package:swapxchange/ui/home/product/product_detail/sections/save_btn.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/strings.dart';
import 'package:swapxchange/utils/styles.dart';

class ProductDetail extends StatelessWidget {
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
                            'Infinix 3 plus'.toUpperCase(),
                            style: H2Style.copyWith(),
                          ),
                          Spacer(),
                          Text(
                            '₦30234.23',
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
                            'Ogui road Enugu • 12km',
                            style: StyleCategorySubTitle,
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      CallChatItem(
                        imgPath: 'images/icon-call.png',
                        title: 'call for free',
                        onClick: () => null,
                      ),
                      SizedBox(height: 24),
                      CallChatItem(
                        imgPath: 'images/icon-chat.png',
                        title: 'start chat',
                        onClick: () => null,
                      ),
                      SizedBox(height: 24),
                      Text('CATEGORY', style: H3Style),
                      SizedBox(height: 8),
                      Text('Mobile phones', style: StyleNormal),
                      SizedBox(height: 24),
                      Text('DESCRIPTION', style: H3Style),
                      SizedBox(height: 8),
                      Text(lorem.substring(0, 100), style: StyleNormal),
                      SizedBox(height: 24),
                      Text('POSTED BY', style: H3Style),
                      SizedBox(height: 8),
                      Text('Nelson Nedum on March 23,2021', style: StyleNormal),
                      SizedBox(height: 24),
                      Text('USER\'S INTEREST', style: H3Style),
                      SizedBox(height: 8),
                      InterestAndSwapButton(),
                      SizedBox(height: 8),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  const CallChatItem(
      {Key? key,
      required this.imgPath,
      required this.title,
      required this.onClick})
      : super(key: key);
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
