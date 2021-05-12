import 'package:flutter/material.dart';
import 'package:swapxchange/ui/home/tabs/home/top_deals.dart';
import 'package:swapxchange/utils/colors.dart';

class InterestAndSwapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: 3,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CategoryBtn(
                  title: 'Holy rock',
                  size: 40,
                  textSize: 10,
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(width: 8),
            ),
          ),
          SizedBox(width: 12),
          InkWell(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'SWAP',
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
