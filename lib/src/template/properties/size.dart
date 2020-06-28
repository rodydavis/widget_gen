import 'impl.dart';

class SizeOptionTemplate extends SettingsImpl {
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
    sb.writeln("""
    Size _size = Size(0.0, 0.0);
    if (params[${name}Key] != null) {
      double width = 0;
      double height = 0;
      Map<String, dynamic> _sizeParams = params[${name}Key]['params'];
      width = _sizeParams['0'] ?? 0;
      height = _sizeParams['1'] ?? 0;
      _size = Size(width, height);
    }
    return _size;
""");
    sb.writeln('}');
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.write('''
    params[${name}Key] = {
      "name" : "Size",
      "id" : "${name}KeySize",
      "params" : {
        "0" : val.width,
        "1" : val.height,
      }
    };
''');
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }
}
