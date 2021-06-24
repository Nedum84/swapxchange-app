import 'package:flutter/material.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/strings.dart';
import 'package:swapxchange/utils/styles.dart';

class FaqModel {
  // FaqModel(this.title, [this.description = const <FaqModel>[]]);
  FaqModel({required this.title, required this.description});

  final String title;
  final String description;
}

class Faqs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: KColors.WHITE_GREY,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
          child: CustomAppbar(
            title: 'FAQs',
          ),
        ),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemBuilder: (BuildContext context, int index) => FaqItem(data[index]),
          itemCount: data.length,
          separatorBuilder: (ctx, idx) => SizedBox(height: 12),
        ),
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  const FaqItem(this.faq);

  final FaqModel faq;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white70,
      childrenPadding: EdgeInsets.only(bottom: 12, left: 16),
      expandedAlignment: Alignment.topLeft,
      title: Text(
        faq.title,
        style: H3Style.copyWith(
          color: KColors.TEXT_COLOR_DARK,
          fontWeight: FontWeight.normal,
        ),
      ),
      children: [
        Text(
          faq.description,
          style: StyleNormal.copyWith(),
        )
      ],
    );
  }
}

final List<FaqModel> data = <FaqModel>[
  FaqModel(
    title: 'How to shop at SwapXchane',
    description: lorem.substring(0, 200),
  ),
  FaqModel(
    title: 'How to shop at SwapXchane',
    description: lorem.substring(0, 100),
  ),
  FaqModel(
    title: 'How to shop at SwapXchane',
    description: lorem.substring(0, 200),
  ),
  FaqModel(
    title: 'How to shop at SwapXchane',
    description: lorem.substring(0, 150),
  ),
  FaqModel(
    title: 'How to shop at SwapXchane',
    description: lorem.substring(0, 20),
  ),
];
