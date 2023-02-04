import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class CloseDealWidget extends StatelessWidget {
  final Function() onCloseDeal;
  final Function() onDeclineDeal;
  final String closeDealText;
  final bool showRejectDealBtn;

  const CloseDealWidget({
    Key? key,
    required this.onCloseDeal,
    required this.onDeclineDeal,
    required this.closeDealText,
    required this.showRejectDealBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 6,
      left: 6,
      right: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onCloseDeal,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: KColors.PRIMARY.withOpacity(.5),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  Text(
                    '$closeDealText',
                    style: StyleNormal.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          if (showRejectDealBtn)
            InkWell(
              onTap: onDeclineDeal,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: KColors.RED.withOpacity(.8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    Text(
                      'Decline deal',
                      style: StyleNormal.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
