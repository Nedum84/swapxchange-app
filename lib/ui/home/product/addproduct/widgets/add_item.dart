import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class AddItem extends StatelessWidget {
  final Function() onClick;
  final String title;
  final String? subtitle;
  final Widget? subtitle2;
  final String? trailing;
  final double? subtitleFont;

  const AddItem({
    Key? key,
    required this.onClick,
    required this.title,
    this.subtitle,
    this.subtitle2,
    this.trailing,
    this.subtitleFont,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: onClick,
        title: Text(
          title,
          style: StyleNormal.copyWith(fontSize: 12),
        ),
        subtitle: subtitle2 ??
            (subtitle == null || subtitle!.isEmpty
                ? null
                : Text(
                    (subtitle ?? ""),
                    style: StyleNormal.copyWith(
                      color: KColors.TEXT_COLOR_DARK,
                      fontSize: subtitleFont ?? 16,
                    ),
                  )),
        trailing: trailing == null
            ? Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blueGrey[800]!.withOpacity(0.4),
              )
            : Text(
                trailing!,
                style: StyleNormal.copyWith(
                  color: KColors.TEXT_COLOR_DARK,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
