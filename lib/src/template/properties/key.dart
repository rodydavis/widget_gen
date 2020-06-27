import 'impl.dart';

class KeyOptionTemplate extends SettingsImpl {
  String defaultValue;
  bool isPrivate;

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
    sb.write("""
    String _val = params[${name}Key].toString();
    if (_val.startsWith('#')) {
      _val = _val.substring(1);
      if (_val.startsWith('ValueKey')) {
        _val = _val.replaceAll('ValueKey', '');
        _val = _val.replaceAll('<String>', '');
        _val = _val.replaceAll('(', '');
        _val = _val.replaceAll(')', '');
      }
    }
    return ValueKey('\$_val')
    """);
    sb.writeln(';');
    sb.writeln('}');
    if (defaultValue != null) {
      sb.writeln("return ValueKey<String>('$defaultValue');");
    } else {
      sb.writeln("return null;");
    }
    sb.writeln('}');
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.write("""
    if (val == null) {
      params[${name}Key] = null;
    } else {
      params[${name}Key] = "#ValueKey('\$val')";
    }
    """);
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }
}
