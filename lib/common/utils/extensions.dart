import 'package:flutter/material.dart';
import 'dart:ui' as ui;

extension BoolToString on bool {
  String toText() {
    return this ? 'Enabled' : 'Disabled';
  }
}

extension ExecuteDelayedUtils<T> on T Function() {
  Future<T> executeDelayed(Duration dur) async {
    return await Future.delayed(dur, this);
  }

  Future<T> executeAfterDelay({int durationMS = 2000}) async {
    return await executeDelayed(Duration(milliseconds: durationMS));
  }

  T? ignoreError() {
    try {
      return this();
    } catch (_) {
      return null;
    }
  }
}

extension DENumberUtils<E extends num> on E {
  E withMinimum(E min) {
    if (this < min) return min;
    return this;
  }

  E withMaximum(E max) {
    if (this > max) return max;
    return this;
  }
}

extension ClamperExtDouble on double {
  double clampDouble(double min, double max) {
    assert(min <= max && !max.isNaN && !min.isNaN);
    var x = this;
    if (x < min) return min;
    if (x > max) return max;
    if (x.isNaN) return max;
    return x;
  }
}

extension DEWidgetsSeparator on Iterable<Widget> {
  Iterable<Widget> addSeparators({
    required Widget separator,
    int skipFirst = 0,
  }) sync* {
    final iterator = this.iterator;
    int count = 0;

    while (iterator.moveNext()) {
      if (count < skipFirst) {
        yield iterator.current;
      } else {
        yield separator;
        yield iterator.current;
      }
      count++;
    }
  }
}

extension ContextUtils on BuildContext {
  ui.FlutterView get view => View.of(this);
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  Orientation get orientation => MediaQuery.orientationOf(this);
  double get pixelRatio => MediaQuery.devicePixelRatioOf(this);

  Size get size => MediaQuery.sizeOf(this);
  double get height => size.height;
  double get width => size.width;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  Brightness get brightness => Theme.brightnessOf(this);
  bool get isDarkMode => brightness == Brightness.dark;

  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;
}
