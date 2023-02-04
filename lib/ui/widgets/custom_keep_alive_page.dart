import 'package:flutter/material.dart';

class CustomKeepAlivePage extends StatefulWidget {
  CustomKeepAlivePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _CustomKeepAlivePageState createState() => _CustomKeepAlivePageState();
}

class _CustomKeepAlivePageState extends State<CustomKeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);
    return widget.child;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
