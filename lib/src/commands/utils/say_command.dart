import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

ChatCommand sayCommand = ChatCommand(
  'say',
  'Repite el mensaje que tu le proporciones',
  aliases: ['speak'],
  id('say', (
    InteractionChatContext context,
    @Name('mensaje') @Description('El mensaje que quieres que la bot repita')
    String? message
    ) async {
    context.respond(MessageBuilder(
      content: message,
      allowedMentions: AllowedMentions(
        repliedUser: false
      )
    ));
  })
);

