import 'impl.dart';

class EdgeInsetsOptionTemplate extends SettingsImpl {
  bool isPrivate;
  double defaultValue;

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
    EdgeInsets _spacing = EdgeInsets.all(0.0);
    if (params[${name}Key] != null) {
      double top = 0;
      double bottom = 0;
      double left = 0;
      double right = 0;
      Map<String, dynamic> _spacingParams = params[${name}Key]['params'];
      top = _spacingParams['top'] ?? 0;
      bottom = _spacingParams['bottom'] ?? 0;
      left = _spacingParams['left'] ?? 0;
      right = _spacingParams['right'] ?? 0;
      _spacing = EdgeInsets.fromLTRB(left, top, right, bottom);
    }
    return _spacing;
""");
    sb.writeln('}');
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.write('''
    params[${name}Key] = {
      "name" : "EdgeInsets.only",
      "id" : "${name}KeyEdgeInsets",
      "params" : {
        "top" : val.top,
        "bottom" : val.bottom,
        "left" : val.left,
        "right" : val.right,
      }
    };
''');
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }
}
