import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/question_mark.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class ChatSwapSuggestion extends StatelessWidget {
  final String chatMsg;

  const ChatSwapSuggestion({Key? key, required this.chatMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var twoProducts = chatMsg.split("@@@");
    var pOne = twoProducts[0].split("@@");
    var pTwo = twoProducts[1].split("@@");

    bool isSecondSet = twoProducts[1] != "0" && pTwo.length > 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductExchangeWidget(
            pData: pOne,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                '- - -',
                textAlign: TextAlign.center,
                style: StyleNormal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Icon(Icons.sync, color: KColors.TEXT_COLOR),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                '- - -',
                textAlign: TextAlign.center,
                style: StyleNormal,
              ),
            ),
          ),
          ProductExchangeWidget(
            pData: isSecondSet ? pTwo : null,
          ),
        ],
      ),
    );
  }
}

class ProductExchangeWidget extends StatelessWidget {
  final List? pData;

  const ProductExchangeWidget({
    Key? key,
    this.pData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (pData != null)
            ? CachedImage(
                pData![2].toString().trim(),
                width: 60,
                height: 60,
                radius: 6,
              )
            : QuestionMark(),
        SizedBox(height: 4),
        Container(
          width: 60,
          child: Text(
            (pData != null) ? pData![1] : "",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: StyleNormal,
          ),
        ),
      ],
    );
  }
}
