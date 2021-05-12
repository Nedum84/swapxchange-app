import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class WalletHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.black26.withOpacity(.2),
          iconTheme: IconThemeData(
            color: KColors.TEXT_COLOR_DARK, //change your color here
          ),
          title: Text(
            'History',
            style: H1Style,
          ),
          bottom: TabBar(
            labelColor: KColors.TEXT_COLOR_DARK,
            unselectedLabelColor: KColors.TEXT_COLOR_LIGHT2,
            labelStyle: StyleNormal.copyWith(fontWeight: FontWeight.w900),
            indicatorColor: Colors.transparent,
            tabs: <Widget>[
              Tab(text: "CREDIT"),
              Tab(text: "PURCHASE"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SubPage(),
            SubPage(),
          ],
        ),
      ),
    );
  }
}

class SubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => HistoryItem(
        imgSrc: 'images/logo.jpg',
        title: 'Daily coins',
        amount: '1200',
        subTitle: 'yesterday at v12:98pm',
        isCredit: index % 3 == 0,
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String imgSrc;
  final String title;
  final String subTitle;
  final String amount;
  final bool isCredit;

  const HistoryItem(
      {Key? key,
      required this.imgSrc,
      required this.title,
      required this.subTitle,
      required this.amount,
      this.isCredit = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: StyleNormal.copyWith(
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subTitle,
        style: StyleNormal.copyWith(
          color: KColors.TEXT_COLOR_LIGHT2,
          fontSize: 12,
        ),
      ),
      leading: Image.asset(
        imgSrc,
        width: 40,
        height: 40,
      ),
      trailing: Text(
        isCredit ? '+$amount' : '-$amount',
        style: StyleNormal.copyWith(
          color: isCredit ? KColors.PRIMARY : KColors.RED,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
