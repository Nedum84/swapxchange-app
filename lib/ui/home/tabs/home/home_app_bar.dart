import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/home/search/product_search.dart';
import 'package:swapxchange/utils/colors.dart';

class HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MenuIcon(
            icon: Icons.search,
            onClick: () => Get.to(() => ProductSearch()),
          ),
          MenuBadge(
            icon: Icons.notifications_none,
            onClick: () => null,
          )
        ],
      ),
    );
  }
}

class MenuIcon extends StatelessWidget {
  final IconData icon;
  final Function() onClick;

  const MenuIcon({Key? key, required this.icon, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(
          icon,
          color: Color(0xff707070),
          size: 28,
        ),
        onPressed: onClick,
      ),
    );
  }
}

class MenuBadge extends StatelessWidget {
  final IconData icon;
  final Function() onClick;

  const MenuBadge({Key? key, required this.icon, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: Color(0xff707070),
              size: 28,
            ),
            Positioned(
              bottom: -8,
              left: -4,
              child: CustomBadge(),
            )
          ],
        ),
      ),
    );
  }
}

class CustomBadge extends StatelessWidget {
  final String? text;
  final bool isRound;
  final Color? bgColor;
  final double? py;

  const CustomBadge({Key? key, this.text, this.isRound = false, this.bgColor, this.py}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: py ?? 4, horizontal: isRound ? 4 : 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor ?? KColors.PRIMARY,
      ),
      child: Text(
        text ?? '0',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
