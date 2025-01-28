import 'dart:convert';
import 'dart:io';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:path/path.dart' as path;
import 'package:swyvi_discord_bot/src/utils/get_random_color.dart';
import 'package:swyvi_discord_bot/src/utils/to_list.dart';
import 'package:swyvi_discord_bot/src/utils/utils.dart';

ChatCommand snipeCommand = ChatCommand(
  'snipe',
  'Revela el último mensaje borrado en el canal.',
  aliases: ['deleted'],
  id('snipe', (ChatContext context) async {
    if (context.guild == null) {
      context.respond(MessageBuilder(
        content: '¡Este comando solo se puede usar dentro de un servidor!',
        allowedMentions: AllowedMentions(
          repliedUser: false
        )
      ));
    }

    User author = await context.user.fetch();
    // User client = await context.client.user.fetch();

    var [r, g, b] = getRandomPastelColor();

    String swyTempDataPath = Platform.environment['SWY_TEMP']!;
    File snipeFile = File(path.join(swyTempDataPath, '${context.guild!.id}.guildmsgs.json'));

    String snipeCnt = snipeFile.readAsStringSync();
    Map<String, dynamic> snipeJson = jsonDecode(snipeCnt);
    List deletedMessages = snipeJson['main']['ch-${context.channel.id}'];

    ChannelMessage msgData = ChannelMessage.fromMap(deletedMessages.last);

    var msgAuthor = await context.client.users.fetch(msgData.authorID!);

    EmbedBuilder snipeEmbed = EmbedBuilder(
      author: EmbedAuthorBuilder(
        name: msgAuthor.globalName ?? msgAuthor.username,
        iconUrl: msgAuthor.avatar.url,
      ),
      title: '<#${context.channel.id}> \u2022 <t:${msgData.timestamp}:t>',
      description: '${msgData.message}\n',
      footer: EmbedFooterBuilder(
        text: 'Solicitado por ${author.username}',
        iconUrl: author.avatar.url,
      ),
      fields: [],
      color: DiscordColor.fromRgb(r, g, b),
    );

    if (msgData.attachmentCount! == 1) {
      snipeEmbed.image = EmbedImageBuilder(
        url: Uri.parse(msgData.attachmentList!.first)
      );
    } else if (msgData.attachmentCount! > 1) {
      snipeEmbed.fields!.add(EmbedFieldBuilder(
        name: '🖇️ Adjuntos',
        value: toOrderedTextList(msgData.attachmentList!),
        isInline: false
      ));
    }

    context.respond(MessageBuilder(
      embeds: [snipeEmbed],
      allowedMentions: AllowedMentions(
        repliedUser: false
      )
    ));
  })
);
