import 'impl.dart';

class OffsetOptionTemplate extends SettingsImpl {
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
    Offset _offset = Offset(0.0, 0.0);
    if (params[${name}Key] != null) {
      double dx = 0;
      double dy = 0;
      Map<String, dynamic> _offsetParams = params[${name}Key]['params'];
      dx = _offsetParams['0'] ?? 0;
      dy = _offsetParams['1'] ?? 0;
      _offset = Offset(dx, dy);
    }
    return _offset;
""");
    sb.writeln('}');
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.write('''
    params[${name}Key] = {
      "name" : "Offset",
      "id" : "${name}KeyOffset",
      "params" : {
        "0" : val.dx,
        "1" : val.dy,
      }
    };
''');
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }
}
