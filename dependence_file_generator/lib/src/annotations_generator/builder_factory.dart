import 'package:build/build.dart';
import 'package:dependence_file_generator/src/annotations_generator/annotations_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder annotatedElementsBuilder(BuilderOptions options) => LibraryBuilder(
      AnnotationsGenerator(),
      generatedExtension: '.dependence',
      options: options,
    );
