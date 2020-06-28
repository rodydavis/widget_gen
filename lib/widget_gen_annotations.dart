/// Declares configuration of a SettingsStore class.
/// Currently the only configuration used is boolean to indicate generation of toString method (true), or not (false)

class WidgetClass {
  const WidgetClass(
    this.name, {
    this.animated = false,
    this.durationMilliseconds = 250,
    this.preferredHeight,
    this.preferredWidth,
    this.allowTap = true,
  });

  final bool allowTap;
  final bool animated;
  final int durationMilliseconds;
  final String name;
  final double preferredHeight;
  final double preferredWidth;
}

class PropertyClass {
  const PropertyClass(this.name);

  final String name;
}

class PropertyKey {
  const PropertyKey({
    this.defaultValue,
    this.key,
    this.tryParse = false,
  });

  final String defaultValue;
  final String key;
  final bool tryParse;
}

class FunctionKey {
  const FunctionKey({
    this.defaultValue,
    this.key,
  });

  final String defaultValue;
  final String key;
}

class EnumKey {
  const EnumKey({
    this.propertyType,
    this.key,
    this.values,
    this.defaultValue,
  });

  final String defaultValue;
  final String key;
  final String propertyType;
  final List<String> values;
}

class ColorKey {
  const ColorKey({
    this.defaultValue,
    this.key,
  });

  final int defaultValue;
  final String key;
}

class SupportedKey {
  const SupportedKey({
    this.key,
  });

  final String key;
}

class WidgetKey {
  const WidgetKey({
    this.key,
    this.defaultValue,
    this.acceptType,
    this.acceptWidth,
    this.acceptHeight,
  });

  const WidgetKey.sizedWidget({
    this.key,
    this.defaultValue,
    this.acceptWidth,
    this.acceptHeight,
  }) : acceptType = 'WidgetPreferredSizeBaseData';

  const WidgetKey.widget({
    this.key,
    this.defaultValue,
    this.acceptWidth,
    this.acceptHeight,
  }) : acceptType = 'WidgetBaseData';

  final double acceptHeight;
  final String acceptType;
  final double acceptWidth;
  final String defaultValue;
  final String key;
}

class ListWidgetKey {
  const ListWidgetKey({
    this.key,
    this.fallback,
    this.empty = true,
    this.acceptType,
  });

  const ListWidgetKey.widget({
    this.key,
    this.fallback,
    this.empty = true,
  }) : acceptType = 'WidgetBaseData';

  final String acceptType;
  final bool empty;
  final String fallback;
  final String key;
}

class TreeKey {
  const TreeKey({
    this.key,
    this.fallback,
  });

  final String fallback;
  final String key;
}

class Matrix4Key {
  const Matrix4Key({
    this.key,
  });

  final String key;
}

class EdgeInsetsKey {
  const EdgeInsetsKey({
    this.key,
    this.defaultValue = 0,
  });

  final double defaultValue;
  final String key;
}

class IconDataKey {
  const IconDataKey({
    this.defaultValue,
    this.key,
  });

  final int defaultValue;
  final String key;
}
