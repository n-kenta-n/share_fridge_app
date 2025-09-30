import 'package:flutter/material.dart';

class DynamicPadding extends StatelessWidget {
  const DynamicPadding({
    super.key,
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.min = 0,
    this.max,
    required this.child,
  });

  final double left, top, right, bottom; // 0.0〜1.0: 親に対する割合
  final double min; // px下限（論理ピクセル）
  final double? max; // 上限（省略可）
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        double clip(double v) {
          final lo = min;
          final hi = max ?? double.infinity;
          return v.clamp(lo, hi);
        }

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            clip(c.maxWidth * left),
            clip(c.maxHeight * top),
            clip(c.maxWidth * right),
            clip(c.maxHeight * bottom),
          ),
          child: child,
        );
      },
    );
  }
}
