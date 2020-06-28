import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../widget_gen_annotations.dart';
import 'errors.dart';
import 'template/properties/base.dart';
import 'template/properties/color.dart';
import 'template/properties/edge_insets_geometry.dart';
import 'template/properties/enum.dart';
import 'template/properties/function.dart';
import 'template/properties/key.dart';
import 'template/properties/list_widget.dart';
import 'template/properties/matrix_4.dart';
import 'template/properties/supported.dart';
import 'template/properties/widget.dart';
import 'template/util.dart';
import 'template/widget_class_gen.dart';
import 'type_names.dart';

class StoreClassVisitor extends SimpleElementVisitor {
  StoreClassVisitor(
    String publicTypeName,
    ClassElement userClass,
    StoreTemplate template,
  ) : _errors = StoreClassCodegenErrors(publicTypeName) {
    _storeTemplate = template
      ..typeParams.templates.addAll(userClass.typeParameters
          .map((type) => typeParamTemplate(type, typeNameFinder)))
      ..typeArgs.templates.addAll(userClass.typeParameters.map((t) => t.name))
      ..parentTypeName = userClass.name
      ..publicTypeName = publicTypeName
      ..widgetName = getClassName(userClass)
      ..isAnimated = getWidgetIsAnimated(userClass)
      ..allowTap = getAllowTap(userClass)
      ..animatedDurationMilliseconds = getAnimationDuration(userClass);
  }

  StoreTemplate _storeTemplate;
  DartType className;
  Map<String, DartType> fields = {};
  Map<String, dynamic> metaData = {};
  LibraryScopedNameFinder typeNameFinder;

  final StoreClassCodegenErrors _errors;

  String get source {
    if (_errors.hasErrors) {
      log.severe(_errors.message);
      return '';
    }
    return _storeTemplate.toString();
  }

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
    return super.visitConstructorElement(element);
  }

  @override
  void visitClassElement(ClassElement element) {
    if (isWidgetClass(element) || isPropertyClass(element)) {
      _errors.nonAbstractStoreMixinDeclarations
          .addIf(!element.isAbstract, element.name);
    }
    // if the class is annotated to generate toString() method we add the information to the _storeTemplate
    // _storeTemplate.generateToString = hasGeneratedToString(element);
  }

  @override
  void visitFieldElement(FieldElement element) {
    fields[element.name] = element.type;
    metaData[element.name] = element.metadata;
    if (_fieldIsNotValid(element)) {
      return;
    }
    final _enumKey = const TypeChecker.fromRuntime(EnumKey);
    if (_enumKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
      final annotation = _enumKey.firstAnnotationOfExact(element);
      final template = EnumOptionTemplate()
        ..defaultValue = annotation.getField('defaultValue').toStringValue()
        ..key = annotation.getField('key').toStringValue()
        ..values = annotation
            .getField('values')
            .toListValue()
            .map((e) => e.toStringValue())
            .toList()
        ..isPrivate = element.isPrivate
        ..propertyType =
            annotation?.getField('propertyType')?.toStringValue() ??
                element.type.toString()
        ..name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }

    if (element.type.toString() == 'Color') {
      final template = ColorOptionTemplate();
      final _colorKey = const TypeChecker.fromRuntime(ColorKey);
      if (_colorKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
        final annotation = _colorKey.firstAnnotationOfExact(element);
        template.defaultValue =
            annotation.getField('defaultValue').toIntValue();
        template.key = annotation.getField('key').toStringValue();
      }
      template.isPrivate = element.isPrivate;
      template.propertyType = element.type.toString();
      template.name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }

    final _supportedKey = const TypeChecker.fromRuntime(SupportedKey);
    if (_supportedKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
      final template = SupportedOptionTemplate();
      final annotation = _supportedKey.firstAnnotationOfExact(element);
      template.key = annotation.getField('key').toStringValue();
      template.isPrivate = element.isPrivate;
      template.propertyType = element.type.toString();
      template.name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }

    if (element.type.toString() == 'Widget') {
      final template = WidgetOptionTemplate();
      final _widgetKey = const TypeChecker.fromRuntime(WidgetKey);
      if (_widgetKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
        final annotation = _widgetKey.firstAnnotationOfExact(element);
        template.fallback = annotation.getField('defaultValue').toStringValue();
        template.key = annotation.getField('key').toStringValue();
        template.acceptType = annotation.getField('acceptType').toStringValue();
        template.acceptWidth =
            annotation.getField('acceptWidth').toDoubleValue();
        template.acceptHeight =
            annotation.getField('acceptHeight').toDoubleValue();
      }
      template.isPrivate = element.isPrivate;
      template.propertyType = element.type.toString();
      template.name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }

    if (element.type.toString() == 'Matrix4') {
      final template = Matrix4OptionTemplate();
      final _widgetKey = const TypeChecker.fromRuntime(Matrix4Key);
      if (_widgetKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
        final annotation = _widgetKey.firstAnnotationOfExact(element);
        template.key = annotation.getField('key').toStringValue();
      }
      template.isPrivate = element.isPrivate;
      template.propertyType = element.type.toString();
      template.name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }
    if (element.type.toString() == 'EdgeInsets') {
      final template = EdgeInsetsOptionTemplate();
      final _widgetKey = const TypeChecker.fromRuntime(EdgeInsetsKey);
      if (_widgetKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
        final annotation = _widgetKey.firstAnnotationOfExact(element);
        template.key = annotation.getField('key').toStringValue();
        template.defaultValue =
            annotation.getField('defaultValue').toDoubleValue();
      }
      template.isPrivate = element.isPrivate;
      template.propertyType = element.type.toString();
      template.name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }

    if (element.type.toString() == 'List<Widget>') {
      final template = ListWidgetOptionTemplate();
      final _widgetKey = const TypeChecker.fromRuntime(ListWidgetKey);
      if (_widgetKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
        final annotation = _widgetKey.firstAnnotationOfExact(element);
        template.fallback = annotation.getField('fallback').toStringValue();
        template.key = annotation.getField('key').toStringValue();
        template.empty = annotation.getField('empty').toBoolValue();
        template.acceptType = annotation.getField('acceptType').toStringValue();
      }
      template.acceptType ??= 'WidgetBaseData';
      template.empty ??= true;
      template.isPrivate = element.isPrivate;
      template.propertyType = element.type.toString();
      template.name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }

    if (element.type.toString() == 'Function') {
      final template = FunctionOptionTemplate();
      final _widgetKey = const TypeChecker.fromRuntime(FunctionKey);
      if (_widgetKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
        final annotation = _widgetKey.firstAnnotationOfExact(element);
        template.defaultValue = annotation.getField('fallback').toStringValue();
        template.key = annotation.getField('key').toStringValue();
      }
      template.isPrivate = element.isPrivate;
      template.propertyType = element.type.toString();
      template.name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }

    if (element.type.toString() == 'Key') {
      final template = KeyOptionTemplate();
      final _widgetKey = const TypeChecker.fromRuntime(TreeKey);
      if (_widgetKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
        final annotation = _widgetKey.firstAnnotationOfExact(element);
        template.defaultValue =
            annotation.getField('defaultValue').toStringValue();
        template.key = annotation.getField('key').toStringValue();
      }
      template.isPrivate = element.isPrivate;
      template.propertyType = element.type.toString();
      template.name = element.name;
      _storeTemplate.settings.add(template);
      return;
    }

    const _ignoreFields = [
      'widgetData',
      'widgetContext',
      'widgetRender',
    ];
    if (_ignoreFields.contains(element.name)) {
      return;
    }
    const _allowedTypes = [
      'double',
      'int',
      'num',
      'String',
      'bool',
      'Object',
    ];
    if (!_allowedTypes.contains(element.type.toString())) {
      print('Not Implemented -> ${element.type}');
      return;
    }
    final template = BaseOptionTemplate();
    final _baseKey = const TypeChecker.fromRuntime(PropertyKey);
    if (_baseKey.hasAnnotationOfExact(element, throwOnUnresolved: false)) {
      final annotation = _baseKey.firstAnnotationOfExact(element);
      template.defaultValue =
          annotation.getField('defaultValue').toStringValue();
      template.key = annotation.getField('key').toStringValue();
      template.tryParse = annotation.getField('tryParse').toBoolValue();
    } else {
      template.tryParse = false;
    }
    template.isPrivate = element.isPrivate;
    template.propertyType = element.type.toString();
    template.name = element.name;
    _storeTemplate.settings.add(template);
    return;
  }

  bool _fieldIsNotValid(FieldElement element) => _any([
        _errors.staticObservables.addIf(element.isStatic, element.name),
        // _errors.finalObservables.addIf(element.isFinal, element.name)
      ]);
}

const _widgetChecker = TypeChecker.fromRuntime(WidgetClass);
const _propertyChecker = TypeChecker.fromRuntime(PropertyClass);

// Checks if the class as a toString annotation
bool isWidgetClass(ClassElement classElement) =>
    _widgetChecker.hasAnnotationOfExact(classElement);
bool isPropertyClass(ClassElement classElement) =>
    _propertyChecker.hasAnnotationOfExact(classElement);

String getClassName(ClassElement classElement) {
  if (isWidgetClass(classElement)) {
    final annotation = _widgetChecker.firstAnnotationOfExact(classElement);
    return annotation.getField('name').toStringValue();
  }
  if (isPropertyClass(classElement)) {
    final annotation = _propertyChecker.firstAnnotationOfExact(classElement);
    return annotation.getField('name').toStringValue();
  }
  return null;
}

bool getWidgetIsAnimated(ClassElement classElement) {
  if (isWidgetClass(classElement)) {
    final annotation = _widgetChecker.firstAnnotationOfExact(classElement);
    return annotation.getField('animated').toBoolValue();
  }
  return false;
}

int getAnimationDuration(ClassElement classElement) {
  if (isWidgetClass(classElement)) {
    final annotation = _widgetChecker.firstAnnotationOfExact(classElement);
    return annotation.getField('durationMilliseconds').toIntValue();
  }
  return 250;
}

double getPreferredHeight(ClassElement classElement) {
  if (isWidgetClass(classElement)) {
    final annotation = _widgetChecker.firstAnnotationOfExact(classElement);
    return annotation.getField('preferredHeight').toDoubleValue();
  }
  return null;
}

double getPreferredWidth(ClassElement classElement) {
  if (isWidgetClass(classElement)) {
    final annotation = _widgetChecker.firstAnnotationOfExact(classElement);
    return annotation.getField('preferredWidth').toDoubleValue();
  }
  return null;
}

bool getAllowTap(ClassElement classElement) {
  if (isWidgetClass(classElement)) {
    final annotation = _widgetChecker.firstAnnotationOfExact(classElement);
    return annotation.getField('allowTap').toBoolValue();
  }
  return false;
}

bool _any(List<bool> list) => list.any(_identity);

T _identity<T>(T value) => value;
