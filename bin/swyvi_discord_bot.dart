import 'dart:convert';
import 'dart:io';
// import 'dart:js_interop';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart' as path;

import 'package:swyvi_discord_bot/src/utils/utils.dart';

// Load all commands
import 'package:swyvi_discord_bot/swyvi_discord_bot.dart';

void main() async {
  final environ = DotEnv(includePlatformEnvironment: true)..load();

  CommandsPlugin commands = CommandsPlugin(
    prefix: (MessageCreateEvent ev) {
      return '&';
    },

    guild: Snowflake.parse(environ['SWY_TEST_GUILD'] as String),

    options: CommandsOptions(
      logErrors: false,
    )
  );

  // Add all commands
  commands.addCommand(helpCommand);
  commands.addCommand(snipeCommand);
  commands.addCommand(inviteCommand);

  final bot = await Nyxx.connectGateway(
    environ['SWY_AUTH_SECRET'] as String,
    GatewayIntents.all,
    options: GatewayClientOptions(
      plugins: [
        commands,
        logging,
        IgnoreExceptions(),
        CliIntegration()
      ],

    )
  );

  bot.onMessageDelete.listen((MessageDeleteEvent ev) {
    if (ev.guild == null) return;
    if (ev.deletedMessage!.author.id == bot.user.id) return;

    DateTime cdate = DateTime.now();
    int timestamp = cdate.millisecondsSinceEpoch;

    String swyTempDataPath = Platform.environment['SWY_TEMP']!;
    Directory swyTempDataDir = Directory(swyTempDataPath);

    if (!swyTempDataDir.existsSync()) {
      swyTempDataDir.createSync(recursive: true);
    }

    List<FileSystemEntity> swyTempDataEntities = swyTempDataDir.listSync();
    List<String> swyTempDataChildren = [];

    for (final child in swyTempDataEntities) {
      swyTempDataChildren.add(child.uri.pathSegments.last);
    }

    for (final g in bot.guilds.cache.keys) {
      if (!swyTempDataChildren.contains('$g.guildmsgs.json')) {
        File snipeFile = File(path.join(swyTempDataPath, '$g.guildmsgs.json'));
        snipeFile.createSync();

        snipeFile.writeAsStringSync('{ "timestamp": "$timestamp", "main": {} }');
      }
    }

    File snipeFile = File(path.join(swyTempDataPath, '${ev.guildId}.guildmsgs.json'));

    String snipeCnt = snipeFile.readAsStringSync();
    Map<String, dynamic> snipeJson = jsonDecode(snipeCnt);

    List<String> attachmentUrlsList = [];

    if (ev.deletedMessage!.attachments.isNotEmpty) {
      for (final att in ev.deletedMessage!.attachments) {
        attachmentUrlsList.add(att.url.toString());
      }
    }

    if (snipeJson['main']['ch-${ev.channelId}'] is List) {
      List<dynamic> channelMsgs = snipeJson['main']['ch-${ev.channelId}'];
      channelMsgs.add(ChannelMessage(
        authorID: ev.deletedMessage!.author.id,
        authorAvatarURL: ev.deletedMessage!.author.avatar!.url,
        message: ev.deletedMessage!.content,
        attachmentCount: attachmentUrlsList.length,
        attachmentList: attachmentUrlsList
      ).toMap());
    } else {
      snipeJson['main']['ch-${ev.channelId}'] = [ChannelMessage(
        authorID: ev.deletedMessage!.author.id,
        authorAvatarURL: ev.deletedMessage!.author.avatar!.url,
        message: ev.deletedMessage!.content,
        attachmentCount: attachmentUrlsList.length,
        attachmentList: attachmentUrlsList
      ).toMap()];
    }

    snipeFile.writeAsStringSync(jsonEncode(snipeJson));
  });
}
