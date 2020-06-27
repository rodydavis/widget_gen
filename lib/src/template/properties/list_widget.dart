import 'impl.dart';

class ListWidgetOptionTemplate extends SettingsImpl {
  String fallback;
  bool isPrivate;
  bool empty;
  String acceptType;

  @override
  String name;

  @override
  String key;

  @override
  String propertyType;

  @override
  String access() {
    final sb = StringBuffer();
    sb.writeln('final _${name}Listen = ValueNotifier<bool>(false);');
    sb.writeln('List<WidgetBase> get ${name}Val {');
    sb.write("if (params[${name}Key] != null) ");
    sb.writeln('{');
    sb.write("""
    final _children = <WidgetBase>[];
    final _list = List.from(params[${name}Key]);
    for (final item in _list) {
      if (item is Map<String, dynamic>) {
        _children.add(widgetRender(item));
      }
    }
    return _children;
    """);
    sb.writeln('}');
    if (fallback != null) {
      final random = DateTime.now().millisecondsSinceEpoch.toString();
      sb.writeln("""
      return [
        widgetRender({
        'id': '$random',
        'name': '$fallback',
        'params': {},
      })
      ];
      """);
    } else {
      sb.writeln("return null;");
    }
    sb.writeln('}');
    sb.writeln('void ${name}ValUpdate(Map<String, dynamic> val) {');
    sb.write("""
    if (params[${name}Key] == null) {
      params[${name}Key] = [];
    }
    params[${name}Key].add(val);
    """);
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
    sb.write("""
      ${name}Val == null && !widgetContext.isDragging ? ${empty ? '[]' : 'null'} :  [
         if (${name}Val != null)
         for (final item in ${name}Val) item.build(context),
      """);
    if (acceptType != null && acceptType.isNotEmpty) {
      sb.write("""
         if (widgetContext.isDragging)
         DragTarget<$acceptType>(
          onAccept: (val) {
            _${name}Listen.value = false;
            if (val != null) {
              ${name}ValUpdate(val?.data);
            }
          },
          onLeave: (val) {
            _${name}Listen.value = false;
          },
          onWillAccept: (val) {
            _${name}Listen.value = true;
            return _${name}Listen.value;
          },
          builder: (context, accepted, rejected) {
            return ValueListenableBuilder<bool>(
              valueListenable: _${name}Listen,
              builder: (context, _accepting, child) => SizedBox.fromSize(
              size: Size(${30}, ${30}),
              child: Placeholder(
                  color: !_accepting ? 
                      Colors.grey : 
                      Theme.of(context).accentColor,
              ),
            ));
          },
        ),
      """);
    }
    sb.writeln('],');
    return sb.toString();
  }
}
