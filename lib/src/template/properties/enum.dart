import 'impl.dart';

class EnumOptionTemplate extends SettingsImpl {
  String defaultValue;
  bool isPrivate;
  List values;

  @override
  String name;

  @override
  String key;

  @override
  String propertyType;

  @override
  String access() {
    final sb = StringBuffer();
    sb.writeln("List<$propertyType> get ${name}Values => [");
    for (final item in values) {
      sb.writeln("${_getEnumValueFromString(item)},");
    }
    sb.writeln("];");
    sb.writeln('');
    sb.writeln('$propertyType get ${name}Val {');
    sb.write("if (params[${name}Key] != null) ");
    sb.writeln('{');
    sb.write('final _value = ');
    sb.writeln("params[${name}Key].toString().replaceAll('#', '');");
    final _fallback =
        defaultValue == null ? null : _getEnumValueFromString(defaultValue);
    sb.writeln("""
    return ${name}Values.firstWhere(
      (element) => element.toString() == _value,
      orElse: () => $_fallback,
    )
    """);
    sb.writeln(';');
    sb.writeln('}');
    sb.writeln("return $_fallback;");
    sb.writeln('}');
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.writeln('params[${name}Key] = "\$val";');
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }

  String _getEnumValueFromString(item) {
    if (item == null) return '';
    String description = item.toString().replaceAll('#', '');
    // if (!description.contains('(')) {
    //   return "$propertyType." + describeEnum(item);
    // }
    return description;
  }
}

T getEnum<T>(String val, {T fallback, List<T> values}) {
  if (val == null) return fallback;
  final _value = val.replaceAll('#', '');
  return values.firstWhere(
    (element) => element.toString() == _value,
    orElse: () => null,
  );
}

String describeEnum(String enumEntry) {
  final String description = enumEntry.toString();
  if (!description.contains('.')) {
    return description;
  }
  final int indexOfDot = description.indexOf('.');
  assert(indexOfDot != -1 && indexOfDot < description.length - 1);
  return description.substring(indexOfDot + 1);
}
