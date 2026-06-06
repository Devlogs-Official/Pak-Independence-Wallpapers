import 'dart:math';

import 'package:flutter/widgets.dart';

class ResponsiveValues {
  const ResponsiveValues._();

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return min(24, max(18, width * 0.052));
  }

  static double contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return min(width, 560);
  }
}
