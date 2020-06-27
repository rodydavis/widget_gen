import 'impl.dart';

class Matrix4OptionTemplate extends SettingsImpl {
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
    final _matrix = Matrix4.identity();
    if (params[${name}Key] != null) {
      if (params[${name}Key] is List) {
        final values = List.from(params[${name}Key]);
        _matrix.setValues(
          values[0],
          values[1],
          values[2],
          values[3],
          values[4],
          values[5],
          values[6],
          values[7],
          values[8],
          values[9],
          values[10],
          values[11],
          values[12],
          values[13],
          values[14],
          values[15],
        );
      } else if (params[${name}Key] is String) {
        final description = params[${name}Key].toString();
        final _entryMatches = 'setEntry('.allMatches(description).toList();
        final _rotateXMatches = 'rotateX('.allMatches(description).toList();
        final _rotateYMatches = 'rotateY('.allMatches(description).toList();
        final _rotateZMatches = 'rotateZ('.allMatches(description).toList();
        for (final idx in _entryMatches) {
          int start = idx.end;
          int end = description.indexOf(')', start);
          final _values = description
              .substring(start, end)
              .split(',')
              .map((e) => num.tryParse(e.trim()))
              .toList();
          _matrix.setEntry(
            _values[0].toInt(),
            _values[1].toInt(),
            _values[2].toDouble(),
          );
        }
        for (final idx in _rotateXMatches) {
          int start = idx.end;
          int end = description.indexOf(')', start);
          final _value = num.tryParse(description.substring(start, end).trim());
          _matrix.rotateX(_value.toDouble());
        }
        for (final idx in _rotateYMatches) {
          int start = idx.end;
          int end = description.indexOf(')', start);
          final _value = num.tryParse(description.substring(start, end).trim());
          _matrix.rotateY(_value.toDouble());
        }
        for (final idx in _rotateZMatches) {
          int start = idx.end;
          int end = description.indexOf(')', start);
          final _value = num.tryParse(description.substring(start, end).trim());
          _matrix.rotateZ(_value.toDouble());
        }
      }
    }
    return _matrix;
""");
    sb.writeln('}');
    sb.writeln('set ${name}Val($propertyType val) {');
    sb.writeln('params[${name}Key] = val.storage.toList();');
    sb.writeln('widgetContext.onUpdate(id, widgetData);');
    sb.writeln('}');
    return sb.toString();
  }
}
