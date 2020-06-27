import 'impl.dart';

class ColorOptionTemplate extends SettingsImpl {
  int defaultValue;
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
    // Getter
    sb.writeln('$propertyType get ${name}Val {');
    sb.write("if (params[${name}Key] != null) ");
    sb.writeln('{');
    sb.writeln('int _value = $defaultValue;');
    sb.write("""
    String description = params[${name}Key].toString();
    if (description.startsWith('#')) {
      description = description.replaceAll('#$propertyType(', '').replaceAll(')', '');
      _value = int.tryParse(description);
    } else if (params[${name}Key] is Map) {
      if (params[${name}Key]['name'] == '$propertyType' 
      && params[${name}Key]['params'] != null 
      && params[${name}Key]['params']['0'] != null) {
        _value = int.tryParse(params[${name}Key]['params']['0']);
      }
    }
""");
    sb.writeln('if (_value != null) {');
    sb.write('return $propertyType(_value);');
    sb.writeln('}');
    sb.writeln('}');
    if (defaultValue != null) {
      sb.writeln("return $propertyType($defaultValue);");
    } else {
      sb.writeln("return null;");
    }
    sb.writeln('}');
    // Setter
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.write('params[${name}Key] = "');
    sb.write('#$propertyType(\${val.value})');
    sb.writeln('";');
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }
}
