import 'package:flutter/material.dart';
import 'package:swapxchange/models/faq_model.dart';
import 'package:swapxchange/repository/repo_faq.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

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
        body: FutureBuilder<List<FaqModel>?>(
            future: RepoFaq.findAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingProgressMultiColor(showBg: false);
              }
              final faqs = snapshot.data;

              if (faqs!.length == 0) {
                return Center(child: Text("No faq found"));
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemBuilder: (BuildContext context, int index) => FaqItem(faqs[index]),
                itemCount: faqs.length,
                separatorBuilder: (ctx, idx) => SizedBox(height: 12),
              );
            }),
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
        faq.question ?? "",
        style: H3Style.copyWith(
          color: KColors.TEXT_COLOR_DARK,
          fontWeight: FontWeight.normal,
        ),
      ),
      children: [
        Text(
          faq.answer ?? "",
          style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_LIGHT2),
        )
      ],
    );
  }
}
