import 'impl.dart';

class SupportedOptionTemplate extends SettingsImpl {
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
    sb.write('return ');
    sb.write('$propertyType(params[${name}Key], widgetContext, widgetRender)');
    sb.writeln(';');
    sb.writeln('}');
    sb.writeln("return null;");
    sb.writeln('}');
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.writeln('params[${name}Key] = val;');
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }

  @override
  String constructor() {
    final sb = StringBuffer();
    sb.write('    ');
    if (key != null && int.tryParse(key) != null) {
      sb.write('');
    } else if (key != null) {
      sb.write("$key: ");
    } else {
      sb.write("$name: ");
    }
    sb.writeln("${name}Val?.build(context)");
    sb.writeln(',');
    return sb.toString();
  }
}
