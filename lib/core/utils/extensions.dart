import 'package:flutter/material.dart';
import 'package:yttrium_music/i18n/translations.g.dart';

extension BoolToString on bool {
  String toText() {
    return this ? t.general.enabled : t.general.disabled;
  }
}

extension ThemeModeToString on ThemeMode {
  String toText() {
    switch (this) {
      case ThemeMode.system:
        return t.setting.iface.appearance.theme.themeMode.system;
      case ThemeMode.light:
        return t.setting.iface.appearance.theme.themeMode.light;
      case ThemeMode.dark:
        return t.setting.iface.appearance.theme.themeMode.dark;
    }
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
