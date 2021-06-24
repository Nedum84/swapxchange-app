import 'package:flutter/material.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/strings.dart';
import 'package:swapxchange/utils/styles.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
        child: CustomAppbar(
          title: 'Terms',
        ),
      ),
      body: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Text('${index + 1}. $lorem', style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_DARK)),
            );
          },
          separatorBuilder: (ctx, idx) => SizedBox(height: 16)),
    );
  }
}
