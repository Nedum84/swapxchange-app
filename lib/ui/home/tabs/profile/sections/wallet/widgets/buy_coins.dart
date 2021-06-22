import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/coins_model.dart';
import 'package:swapxchange/repository/paystack_repo.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class BuyCoins extends StatefulWidget {
  @override
  _BuyCoinsState createState() => _BuyCoinsState();
}

class _BuyCoinsState extends State<BuyCoins> {
  int selectedAmount = CoinsController.coins1000Price;
  final plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: Constants.PAYSTACK_PUBLIC_KEY);
  }

  _chargeCard() async {
    final user = UserController.to.user!;
    String paymentReference = PaystackRepo.genPaymentReference(
      noOfCoins: CoinsController.getCoinsFromAmount(selectedAmount),
      userId: user.userId!,
    );
    Charge charge = Charge()
      ..amount = selectedAmount * 100 //convert to kobo
      // ..amount = 20*100//convert to kobo
      ..reference = paymentReference
      ..email = user.email!.isNotEmpty ? user.email : "${user.name!.toLowerCase().replaceAll(' ', '.')}@swapxchange.shop";
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      AlertUtils.showProgressDialog();
      bool isVerify = await PaystackRepo.verifyOnServer(reference: response.reference!);
      if (isVerify) {
        _buyCoins(reference: response.reference!);
      } else {
        AlertUtils.hideProgressDialog();
        AlertUtils.showCustomDialog(context, body: 'Payment Verification Error, Contact support for further assistance with reference:${response.reference}.');
      }
    } else {
      AlertUtils.showCustomDialog(context, fromTop: false, body: response.message);
    }
  }

  //--> Purchase coins from the server
  _buyCoins({required String reference}) async {
    final addCoins = await CoinsController.to.addCoin(
      amount: CoinsController.getCoinsFromAmount(selectedAmount),
      methodOfSub: MethodOfSubscription.PURCHASE,
      ref: reference,
    );
    AlertUtils.hideProgressDialog();
    if (addCoins != null) {
      AlertUtils.alert(
        'You have successfully purchased ${CoinsController.getCoinsFromAmount(selectedAmount)} coins. Keep shopping/swapping at swapXchange.',
        title: 'Success!!',
      );
    }
  }

  _changeSelAmount(int amount) {
    setState(() => selectedAmount = amount);
  }

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
                amount: '${CoinsController.coins500Price}',
                imgSrc: 'images/coins1.png',
                noOfCoins: '${CoinsController.getCoinsFromAmount(CoinsController.coins500Price)}',
                titleColor: KColors.TEXT_COLOR,
                borderColor: (selectedAmount == CoinsController.coins500Price) ? KColors.PRIMARY : KColors.WHITE_GREY2,
                onClick: () => _changeSelAmount(CoinsController.coins500Price),
              ),
              SizedBox(width: 4),
              CoinBox(
                amount: '${CoinsController.coins1000Price}',
                imgSrc: 'images/coins2.png',
                noOfCoins: '${CoinsController.getCoinsFromAmount(CoinsController.coins1000Price)}',
                percentOff: '5',
                titleColor: Colors.black,
                borderColor: (selectedAmount == CoinsController.coins1000Price) ? KColors.PRIMARY : KColors.WHITE_GREY2,
                onClick: () => _changeSelAmount(CoinsController.coins1000Price),
              ),
              SizedBox(width: 4),
              CoinBox(
                amount: '${CoinsController.coins5000Price}',
                imgSrc: 'images/coins3.png',
                noOfCoins: '${CoinsController.getCoinsFromAmount(CoinsController.coins5000Price)}',
                percentOff: '25',
                titleColor: KColors.TEXT_COLOR,
                borderColor: (selectedAmount == CoinsController.coins5000Price) ? KColors.PRIMARY : KColors.WHITE_GREY2,
                onClick: () => _changeSelAmount(CoinsController.coins5000Price),
              ),
            ],
          ),
          SizedBox(height: 16),
          ButtonSmall(
            onClick: _chargeCard,
            text: 'Buy ${CoinsController.getCoinsFromAmount(selectedAmount)} coins',
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
  final Function() onClick;

  const CoinBox({
    Key? key,
    required this.imgSrc,
    required this.noOfCoins,
    required this.amount,
    this.percentOff,
    required this.titleColor,
    this.borderColor,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Constants.PADDING, horizontal: 4),
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
      ),
    );
  }
}
