import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../types/structs.dart';

Future<GlobalsJSON> readGlobals() async {
  String globalsPath = path.join(Directory.current.path, 'globals.json');
  File globalsFile = File(globalsPath);
  String globalsString = await globalsFile.readAsString();

  return jsonDecode(globalsString);
}
