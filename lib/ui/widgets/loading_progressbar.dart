import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';

class LoadingSpinner extends StatelessWidget {
  final Color bgColor;
  final Color? spinnerColor;
  final Color? spinnerBgColor;
  LoadingSpinner({this.bgColor = Colors.white10, this.spinnerColor, this.spinnerBgColor = Colors.black12});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 30,
        backgroundColor: bgColor,
        child: CircularProgressIndicator(
          // value: 3,
          valueColor: AlwaysStoppedAnimation<Color>(spinnerColor ?? KColors.PRIMARY),
          backgroundColor: spinnerBgColor,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

class LoadingProgressMultiColor extends StatefulWidget {
  final String? title;
  final Color? txtColor;
  final bool showBg;
  final double? stokeWidth;

  LoadingProgressMultiColor({this.title, this.txtColor, this.showBg = true, this.stokeWidth});

  @override
  _LoadingProgressMultiColorPageState createState() => _LoadingProgressMultiColorPageState();
}

class _LoadingProgressMultiColorPageState extends State<LoadingProgressMultiColor> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController?.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: widget.stokeWidth ?? 4,
              valueColor: animationController?.drive(ColorTween(
                begin: KColors.PRIMARY,
                end: KColors.SECONDARY,
              )),
            ),
            if (widget.title != null) SizedBox(height: 8),
            if (widget.title != null)
              Text(
                widget.title!,
                style: TextStyle(
                  color: widget.txtColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
