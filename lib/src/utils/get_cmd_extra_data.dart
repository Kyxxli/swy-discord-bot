import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
// import '../types/structs.dart';

Future<dynamic> getCommandExtraData(String cmd) async {
  String commandPath = path.join(Directory.current.path, 'lib', 'src', 'commands', '${cmd}_command.yml');
  File commandData = File(commandPath);
  String fileContent = await commandData.readAsString();

  return loadYaml(fileContent);
}

String examplesFromArray(YamlList arr) {
  String finalStr = '';

  for (var i = 0;i < arr.length;i++) {
    finalStr += '`${arr[i]}`\n';
  }

  return finalStr;
}
