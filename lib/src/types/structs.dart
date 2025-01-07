import 'package:nyxx/nyxx.dart';

class CommandExtraData {
  String? usage;
  List<String>? examples;
  int? since;

  CommandExtraData({this.usage, this.examples, this.since});
}

class GlobalsJSON {
  Snowflake? swyOwnerID;
}
