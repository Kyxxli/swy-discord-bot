import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

ChatCommand inviteCommand = ChatCommand(
  'invite',
  'Envía el link de invitación de Swy~vi',
  aliases: ['join'],
  id('invite', (ChatContext context) {
    String invLink = 'https://discord.com/oauth2/authorize?client_id=1251440040412708904&permissions=8&integration_type=0&scope=bot+applications.commands';

    context.respond(MessageBuilder(
      content: 'Haz click en el siguiente enlace para invitarme: [Invitar a Swy~vi!]($invLink)'
    ));
  })
);
