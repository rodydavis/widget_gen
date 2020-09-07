import 'impl.dart';

import 'package:shortid/shortid.dart';

class WidgetOptionTemplate extends SettingsImpl {
  String fallback;
  bool isPrivate;
  String acceptType;
  double acceptWidth;
  double acceptHeight;

  @override
  String name;

  @override
  String key;

  @override
  String propertyType;

  @override
  String access() {
    final sb = StringBuffer();
    if (acceptType != null) {
      sb.writeln('final _${name}Listen = ValueNotifier<bool>(false);');
    }
    sb.writeln('WidgetBase get ${name}Val {');
    sb.write("if (params[${name}Key] != null) ");
    sb.writeln('{');
    sb.write('return ');
    sb.write('widgetRender(widgetContext, params[${name}Key])');
    sb.writeln(';');
    sb.writeln('}');
    sb.writeln("return null;");
    sb.writeln('}');
    sb.writeln('void ${name}ValUpdate(Map<String, dynamic> val) {');
    sb.write("""
    final _data = val;
    _data['id'] = '${shortid.generate()}';
    if (_data['name'] == 'Text') {
      _data['params']['style']['id'] = '${shortid.generate()}';
    }
    if (_data['name'] == 'Icon') {
      _data['params']['0']['id'] = '${shortid.generate()}';
    }
    """);
    sb.writeln('params[${name}Key] = _data;');
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
    if (acceptType == null) {
      sb.writeln('${name}Val?.build(context)');
    } else {
      sb.write("""
      !widgetContext.isDragging || (widgetContext.isDragging && ${name}Val?.build(context) != null) ? 
      (
        ${name}Val?.build(context) 
        
      """);
      if (fallback != null) {
        sb.write("""
       ?? (widgetRender(widgetContext, json.decode(json.encode({
        'id': '${shortid.generate()}',
        'name': '$fallback',
        'params': {},
      })))).build(context)
      """);
      }
      sb.write("""
      ) 
      """);
      sb.write("""
      : 
      PreferredSize(
        preferredSize: Size(${acceptWidth ?? 30}, ${acceptHeight ?? 30}),
        child: DragTarget<$acceptType>(
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
              size: Size(${acceptWidth ?? 30}, ${acceptHeight ?? 30}),
              child: Placeholder(
                  color: !_accepting ? 
                      Colors.grey : 
                      Theme.of(context).accentColor,
              ),
            ));
          },
        ),
      )
      """);
    }
    sb.writeln(',');
    return sb.toString();
  }
}
