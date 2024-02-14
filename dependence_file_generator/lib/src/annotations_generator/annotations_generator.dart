import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dartx/dartx.dart';
import 'package:dependence_file_annotation/dependence_file_annotation.dart';
import 'package:source_gen/source_gen.dart';

class AnnotationsGenerator implements Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final elementNames = library
        .annotatedWith(const TypeChecker.fromRuntime(DependenceClass))
        .map((e) => switch (e.element.name) {
              final String name => name,
              _ => throw UnnamedGenerationSourceError(e.element),
            });

    if (elementNames.isEmpty) return null;

    final directive = Directive.export(
      buildStep.inputId.uri.toString(),
      show: elementNames.sorted(),
    );

    final libraryNew = Library((builder) => builder.directives.add(directive));

    final source = libraryNew.accept(DartEmitter()).toString();
    return DartFormatter().format(source);
  }
}

class UnnamedGenerationSourceError extends InvalidGenerationSourceError {
  UnnamedGenerationSourceError(Element element)
      : super(
          "`@DependenceClass` can only be used on elements with a name.",
          element: element,
        );
}
