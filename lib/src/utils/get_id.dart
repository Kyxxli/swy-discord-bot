import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

Snowflake getGuildID(ChatContext context) {
  if (context.guild == null) {
    return context.user.id;
  } else {
    return context.guild!.id;
  }
}

String getGuildName(ChatContext context) {
  if (context.guild == null) {
    return context.user.username;
  } else {
    return context.guild!.name;
  }
}
