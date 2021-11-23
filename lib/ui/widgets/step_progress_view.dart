import 'package:flutter/material.dart';

class StepProgressView extends StatelessWidget {
  StepProgressView(
      {Key? key,
      required int curStep,
      required int itemSize,
      required double width,
      required Color activeColor,
      Color inActiveColor = const Color(0x80FFFFFF)})
      : _itemSize = itemSize,
        _curStep = curStep,
        _width = width,
        _activeColor = activeColor,
        _inactiveColor = inActiveColor,
        // assert(curStep > 0 == true && curStep <= itemSize),
        assert(width > 0),
        super(key: key);

  final double _width;
  final int _itemSize;
  final int _curStep;
  final Color _activeColor;
  final Color _inactiveColor;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 40.0,
        right: 40.0,
      ),
      width: this._width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _iconViews(),
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];

    for (int i = 0; i < _itemSize; i++) {
      var itemColor = (i != _curStep) ? _inactiveColor : _activeColor;

      double itemWidth = (i != _curStep) ? 8 : 30;

      list.add(
        //dot with icon view
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: itemWidth,
          height: 8.0,
          margin: EdgeInsets.all(4),
          decoration: new BoxDecoration(
            color: itemColor,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
          ),
        ),
      );
    }
    ;

    return list;
  }
}
