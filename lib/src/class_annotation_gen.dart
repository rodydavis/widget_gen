import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'store_class_visitor.dart';
import 'template/widget_class_gen.dart';
import 'template/store_file.dart';
import 'type_names.dart';

class WidgetGenerator extends Generator {
  //GeneratorForAnnotation<WidgetClass> {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (library.allElements.isEmpty) {
      return '';
    }

    final typeSystem = await library.allElements.first.session.typeSystem;
    final file = StoreFileTemplate()
      ..storeSources = _generateCodeForLibrary(library, typeSystem).toSet();
    return file.toString();
  }

  Iterable<String> _generateCodeForLibrary(
    LibraryReader library,
    TypeSystem typeSystem,
  ) sync* {
    for (final classElement in library.classes) {
      yield* _generateCodeForMixinStore(
        library,
        classElement,
        typeSystem,
      );
    }
  }

  Iterable<String> _generateCodeForMixinStore(
    LibraryReader library,
    ClassElement baseClass,
    TypeSystem typeSystem,
  ) sync* {
    final typeNameFinder = LibraryScopedNameFinder(library.element);
    String _base;
    double width, height;

    if (isWidgetClass(baseClass)) {
      width = getPreferredWidth(baseClass);
      height = getPreferredHeight(baseClass);
      if (width != null || height != null) {
        _base = 'WidgetPreferredSizedBase';
      } else {
        _base = 'WidgetBase';
      }
    }
    if (isPropertyClass(baseClass)) {
      _base = 'PropertyBase';
    }
    if (_base != null) {
      final _template = MixinStoreTemplate(_base)
        ..width = width
        ..height = height;
      yield _generateCodeFromTemplate(
        baseClass.name,
        baseClass,
        _template,
        typeNameFinder,
      );
    }
  }

  String _generateCodeFromTemplate(
    String publicTypeName,
    ClassElement userStoreClass,
    StoreTemplate template,
    LibraryScopedNameFinder typeNameFinder,
  ) {
    final visitor = StoreClassVisitor(publicTypeName, userStoreClass, template);
    userStoreClass
      ..accept(visitor)
      ..visitChildren(visitor);
    return visitor.source;
  }
}
