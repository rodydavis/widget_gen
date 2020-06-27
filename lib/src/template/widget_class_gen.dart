import 'comma_list.dart';
import 'params.dart';
import 'properties/impl.dart';

class MixinStoreTemplate extends StoreTemplate {
  final String extendsClass;
  double width, height;

  MixinStoreTemplate(this.extendsClass);
  String get typeName => '_\$$publicTypeName';

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln('abstract class $typeName$typeParams extends $extendsClass {');
    for (final setting in settings) {
      sb.write(setting.keyValue());
    }
    sb.writeln('');
    final _hasPreferredSize = width != null || height != null;
    if (_hasPreferredSize) {
      sb.writeln('@override');
      sb.write('Size get preferredSize => ');
      if (width != null && height != null) {
        sb.write('Size($width, $height)');
      } else if (width != null) {
        sb.write('Size.fromWidth($width)');
      } else if (height != null) {
        sb.write('Size.fromHeight($height)');
      }
      sb.writeln(';');
    }
    sb.writeln('');
    sb.writeln('@override');
    sb.writeln('Map<String, String> get properties => {');
    for (final setting in settings) {
      sb.write("'${setting?.key ?? setting.name}'");
      sb.write(':');
      sb.write("'${setting.propertyType}'");
      sb.writeln(',');
    }
    sb.writeln('};');
    sb.writeln('');
    for (final setting in settings) {
      sb.writeln(setting.access());
    }
    sb.writeln('');
    sb.writeln('@override');
    sb.writeln('Object build(BuildContext context) {');
    sb.write('    return ');
    if (allowTap) {
      if (_hasPreferredSize) {
        sb.writeln('PreferredSize(');
        sb.writeln('preferredSize: preferredSize,');
        sb.writeln('child: ');
      }
      sb.writeln('GestureDetector(');
      sb.writeln("onTap: () => widgetContext.onTap(id, widgetData),");
      sb.writeln('child: ');
    }
    if (isAnimated) {
      sb.write('Animated');
    }
    sb.writeln('$widgetName(');
    settings.sort((a, b) => (a?.key ?? a.name).compareTo((b?.key ?? b.name)));
    if (isAnimated) {
      sb.writeln(
          'duration: const Duration(milliseconds: $animatedDurationMilliseconds),');
    }
    for (final setting in settings) {
      sb.writeln(setting.constructor());
    }
    sb.writeln(')');
    if (allowTap) {
      if (_hasPreferredSize) {
        sb.write(',');
        sb.writeln(')');
      }
      sb.write(',');
      sb.writeln(')');
    }
    sb.write(';');
    sb.writeln('}');
    sb.writeln('');
    sb.writeln('}');
    return sb.toString();
  }
}

abstract class StoreTemplate {
  final SurroundedCommaList<TypeParamTemplate> typeParams =
      SurroundedCommaList('<', '>', []);
  final SurroundedCommaList<String> typeArgs =
      SurroundedCommaList('<', '>', []);
  String publicTypeName;
  String parentTypeName;
  String widgetName;
  bool isAnimated;
  int animatedDurationMilliseconds;
  bool allowTap;

  final List<SettingsImpl> settings = [];

  @override
  String toString();
}
