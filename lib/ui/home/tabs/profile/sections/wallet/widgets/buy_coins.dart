import 'package:flutter/material.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class BuyCoins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constants.PADDING,
        horizontal: 24,
      ),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Buy Coins',
            style: H2Style,
          ),
          SizedBox(height: 16),
          Text(
            'Get as much as you want by purchasing SwapXchange coins',
            style: StyleNormal,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              CoinBox(
                amount: '200',
                imgSrc: 'images/logo.jpg',
                noOfCoins: '100',
                titleColor: KColors.TEXT_COLOR,
                borderColor: KColors.WHITE_GREY2,
              ),
              SizedBox(width: 4),
              CoinBox(
                amount: '500',
                imgSrc: 'images/logo.jpg',
                noOfCoins: '800',
                percentOff: '5',
                titleColor: Colors.black,
                borderColor: KColors.PRIMARY,
              ),
              SizedBox(width: 4),
              CoinBox(
                amount: '12000',
                imgSrc: 'images/logo.jpg',
                noOfCoins: '30000',
                percentOff: '25',
                titleColor: KColors.TEXT_COLOR,
                borderColor: KColors.WHITE_GREY2,
              ),
            ],
          ),
          SizedBox(height: 16),
          ButtonSmall(
            onClick: () => null,
            text: 'Buy 100 coins',
            textColor: Colors.white,
            bgColor: KColors.PRIMARY,
            radius: 8,
            py: 8,
          )
        ],
      ),
    );
  }
}

class CoinBox extends StatelessWidget {
  final String imgSrc;
  final String noOfCoins;
  final String amount;
  final String? percentOff;
  final Color titleColor;
  final Color? borderColor;

  const CoinBox(
      {Key? key,
      required this.imgSrc,
      required this.noOfCoins,
      required this.amount,
      this.percentOff,
      required this.titleColor,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: Constants.PADDING, horizontal: 4),
        decoration: BoxDecoration(
            border: Border.all(
              color: borderColor ?? KColors.TEXT_COLOR_LIGHT2,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgSrc,
              width: 40,
            ),
            SizedBox(height: 6),
            Text(
              noOfCoins,
              style: H2Style.copyWith(color: titleColor),
            ),
            SizedBox(height: 2),
            Text(
              'coins',
              style: StyleNormal.copyWith(
                fontSize: 12,
                color: KColors.TEXT_COLOR_LIGHT2,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '₦$amount.00',
              style: StyleNormal.copyWith(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 6),
            Text(
              percentOff != null ? 'SAVE $percentOff%' : '',
              style: StyleNormal.copyWith(
                fontSize: 10,
                color: KColors.PRIMARY,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
