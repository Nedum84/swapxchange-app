import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/coins_model.dart';
import 'package:swapxchange/repository/repo_coins.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/styles.dart';

class WalletHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SubPage(),
    );
  }
}

class SubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoinsModel?>(
        future: RepoCoins.findAllByUserId(userId: UserController.to.user!.userId!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          if (data == null || data.meta?.length == 0) {
            return Center(
              child: Text('No data found!'),
            );
          }
          return ListView.builder(
            itemCount: data.meta?.length,
            itemBuilder: (context, index) {
              final item = data.meta?[index];

              return HistoryItem(
                imgSrc: 'images/logo.jpg',
                title: '${LastCredit.statusFromEnum2(item!.methodOfSubscription!)}',
                amount: '${item.amount}',
                subTitle: '${Helpers.formatDate2(item.createdAt!)}',
                isCredit: item.methodOfSubscription != MethodOfSubscription.TRANSFER,
              );
            },
          );
        });
  }
}

class HistoryItem extends StatelessWidget {
  final String imgSrc;
  final String title;
  final String subTitle;
  final String amount;
  final bool isCredit;

  const HistoryItem({
    Key? key,
    required this.imgSrc,
    required this.title,
    required this.subTitle,
    required this.amount,
    this.isCredit = true,
  }) : super(key: key);

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
      leading: Icon(
        Icons.monochrome_photos,
        size: 32,
        color: KColors.TEXT_COLOR,
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
