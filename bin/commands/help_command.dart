import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

ChatCommand helpCommand = ChatCommand(
  'help', // Name
  
  'Muestra un mensaje de ayuda que contiene categorías y comandos', // Desc

  id('help', (ChatContext context) async { // Main
    User client = await context.client.user.fetch();
    User author = await context.user.fetch();

    // List<dynamic> userArgs = context.arguments;

    EmbedBuilder helpMain = EmbedBuilder(
    author: EmbedAuthorBuilder(
      name: client.username,
      iconUrl: client.avatar.url,
    ),
    color: DiscordColor(0xAD91FF),
    title: '¿Necesitas Ayuda?',
    description: 'Aquí tienes una lista con cada categoría de mis comandos.',
    fields: [
      EmbedFieldBuilder(
        name: 'Información',
        value: '`&help c-info`',
        isInline: false
      )
    ],
    footer: EmbedFooterBuilder(
      text: 'Solicitado por ${author.username}',
      iconUrl: author.avatar.url,
    )
  );

    context.respond(MessageBuilder(
      embeds: [helpMain],
      allowedMentions: AllowedMentions(
        repliedUser: false
      )
    ));
  }),

  aliases: ['h', 'commands']
);