import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../utils/get_cmd_extra_data.dart';
import '../utils/read_globals.dart';
import 'resources/help_category_embeds.dart';

ChatCommand helpCommand = ChatCommand(
  'help',
  'Muestra un mensaje de ayuda que contiene categorías y comandos.',
  aliases: ['h', 'commands'],
  id('help', (
    ChatContext context, [
      @Name('coc') @Description('El comando o categoría que deseas buscar.')
      String? coc
    ]
  ) async {
    User author = await context.user.fetch();
    User client = await context.client.user.fetch();

    // Generar un color pastel aleatorio
    Random rand = Random();

    int r = rand.nextInt(75) + 180;
    int g = rand.nextInt(75) + 180;
    int b = rand.nextInt(75) + 180;

    // Si el usuario no paso el COC, responder con el embed por defecto
    if (context.arguments.isEmpty) {
      EmbedBuilder help = EmbedBuilder(
        author: EmbedAuthorBuilder(
          name: client.username,
          iconUrl: client.avatar.url,
        ),
        color: DiscordColor.fromRgb(r, g, b),
        title: '¿Necesitas Ayuda?',
        description:
        'Aquí tienes una lista con cada categoría de mis comandos. '
        'Si necesitas ver un comando en específico, solo escribe `&help {nombre}` '
        'donde `{nombre}` es el comando que quieras buscar (p.ej.: `&help ban`).\n'
        'En cambio, si quieres buscar una categoría, debes añadir un asterisco (`*`) '
        'al inicio del nombre de la categoría.',
        fields: [
          EmbedFieldBuilder(
            name: 'Información',
            value: '`&help *info`',
            isInline: false
          )
        ],
        footer: EmbedFooterBuilder(
          text: 'Solicitado por ${author.username}',
          iconUrl: author.avatar.url,
        )
      );

      context.respond(MessageBuilder(
        embeds: [help],
        allowedMentions: AllowedMentions(
          repliedUser: false
        )
      ));

      return;
    } else {
      // Si empieza con un asterisco es una categoria
      if (coc.toString().startsWith('*')) {
        switch (coc) {
          case '*info':
            infoEmbed.author = EmbedAuthorBuilder(
              name: client.username,
              iconUrl: client.avatar.url
            );

            infoEmbed.footer = EmbedFooterBuilder(
              text: 'Solicitado por ${author.username}',
              iconUrl: author.avatar.url
            );

            infoEmbed.color = DiscordColor.fromRgb(r, g, b);

            context.respond(MessageBuilder(
              embeds: [infoEmbed],
              allowedMentions: AllowedMentions(
                repliedUser: false
              )
            ));

            return;

          default:
            context.respond(MessageBuilder(
              content: 'La categoría que buscas no existe!',
              allowedMentions: AllowedMentions(
                repliedUser: false
              )
            ));

            return;
        }
      } else {
        try {
          ChatCommand? comm = context.commands.getCommand(StringView(coc!));

          if (comm == null) {
            context.respond(MessageBuilder(
              content: 'El comando que mencionaste no existe!',
              allowedMentions: AllowedMentions(
                repliedUser: false
              )
            ));

            return;
          }

          final commData = await getCommandExtraData(comm.name);

          EmbedBuilder commandEmbed = EmbedBuilder(
            author: EmbedAuthorBuilder(
              name: client.username,
              iconUrl: client.avatar.url,
            ),
            title: '▶️ Comando: ${comm.name}',
            description: comm.description,
            fields: [
              EmbedFieldBuilder(
                name: '📒 Uso',
                value: '`${commData['usage']}`',
                isInline: true
              ),
              EmbedFieldBuilder(
                name: '✏️ Ejemplos',
                value: examplesFromArray(commData['examples']),
                isInline: true
              ),
              EmbedFieldBuilder(
                name: '🔁 Desde',
                value: '`Swy ${commData['since']}`',
                isInline: false
              )
            ],
            color: DiscordColor.fromRgb(r, g, b),
            footer: EmbedFooterBuilder(
              text: 'Solicitado por ${author.username}',
              iconUrl: author.avatar.url
            )
          );

          context.respond(MessageBuilder(
            embeds: [commandEmbed],
            allowedMentions: AllowedMentions(
              repliedUser: false
            )
          ));
        } catch (err) {
          var globals = await readGlobals();

          String reply = context.user.id == globals.swyOwnerID
            ? 'Un error ocurrió al ejecutar el comando:\n```\n$err```'
            : 'Un error ocurrió al ejecutar el comando.';

          context.respond(MessageBuilder(
            content: reply
          ));
        }
      }
    }
  })
);
