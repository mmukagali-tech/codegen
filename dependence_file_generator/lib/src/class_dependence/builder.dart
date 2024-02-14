import 'dart:async';

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';

class DependenceBuilder implements Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final dependencies = await getDependecies(buildStep);

    final content = await buildStep.readAsString(buildStep.inputId);
    final temp = <String, String>{};
    for (final entry in dependencies.entries) {
      final value = entry.value.substring("export '".length, entry.value.length - 1);
      if (content.contains(entry.key) && buildStep.inputId.uri.toString() != value) {
        temp[entry.key] = entry.value;
      }
    }

    if (temp.isEmpty) return;

    final source = temp.entries.fold('', (prev, e) => '$prev\n${e.value} show ${e.key};');

    final newContent = DartFormatter().format(source);

    buildStep.writeAsString(buildStep.inputId.changeExtension('.dependence.dart'), newContent);
  }

  Future<Map<String, String>> getDependecies(BuildStep buildStep) async {
    final glob = Glob('**.dependence');
    final assets = await buildStep.findAssets(glob).toSet();
    final contents = await Future.wait(assets.map((e) => buildStep.readAsString(e)));
    final truncatedContents = <String, String>{
      for (final content in contents) ...<String, String>{
        if (content.substring(content.indexOf('export ')).split(' show ')
            case [String uri, String show])
          for (final element in show.substring(0, show.length - 2).split(', ')) element: uri
      }
    };
    return truncatedContents;
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.dependence.dart']
      };
}
