import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/class_annotation_gen.dart';

Builder widgetGenerator(BuilderOptions options) {
  return SharedPartBuilder([WidgetGenerator()], 'widget_generator');
}
