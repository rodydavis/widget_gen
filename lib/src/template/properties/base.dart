import 'impl.dart';

class BaseOptionTemplate extends SettingsImpl {
  String defaultValue;
  bool isPrivate;
  bool tryParse;

  @override
  String name;

  @override
  String key;

  @override
  String propertyType;

  @override
  String access() {
    final sb = StringBuffer();
    sb.writeln('$propertyType get ${name}Val {');
    sb.write("if (params[${name}Key] != null) ");
    sb.writeln('{');
    sb.write('return ');
    if (tryParse) {
      sb.write("$propertyType.tryParse(params[${name}Key].toString())");
      if (defaultValue != null) {
        sb.write(' ?? $defaultValue');
      }
    } else {
      sb.write('params[${name}Key] as $propertyType');
    }
    sb.writeln(';');
    sb.writeln('}');
    if (defaultValue != null) {
      if (propertyType == 'String') {
        sb.writeln("return '$defaultValue';");
      } else {
        sb.writeln("return $defaultValue;");
      }
    } else {
      sb.writeln("return null;");
    }
    sb.writeln('}');
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.writeln('params[${name}Key] = val;');
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }
}
