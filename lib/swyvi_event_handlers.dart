import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:swyvi_discord_bot/src/utils/to_channel_message.dart';

class EventHandlers {
  void listenCommandPlugin(CommandsPlugin commands) {
    commands.onCommandError.listen(EventHandlers.onCommandError);
  }

  void listenBot(NyxxGateway bot) {
    bot.onReady.listen(EventHandlers.onReady);
    bot.onMessageDelete.listen(EventHandlers.onMessageDelete);
    bot.onGuildCreate.listen(EventHandlers.onGuildCreate);
    bot.onGuildDelete.listen(EventHandlers.onGuildDelete);
  }

  // Bot events
  static void onReady(ReadyEvent ev) {
    print('[>>>] [EVENT::READY] Connected as ${ev.user.username}');

    if (Platform.environment['SWY_TEMP'] == null) {
      print('[@] SWY_TEMP env is not defined. Be aware of further errors.');
    }
  }

  static void onGuildCreate(UnavailableGuildCreateEvent ev) async {
    final guild = await ev.guild.fetch();

    print('[>>>] [EVENT::GUILD_CREATE] Joined guild ${guild.name} with id ${guild.id}\u0007');

    final String swyDataPath = Platform.environment['SWY_DATA']!;
    final Directory swyDataDir = Directory(swyDataPath);

    if (!swyDataDir.existsSync()) {
      swyDataDir.createSync(recursive: true);
    }

    final List<FileSystemEntity> swyDataEntities = swyDataDir.listSync();
    List<String> swyDataChildren = [];

    // Obtener el nombre de cada archivo
    for (final child in swyDataEntities) {
      swyDataChildren.add(child.uri.pathSegments.last);
    }

    // Crear un archivo para cada servidor si no existe
    for (final g in ev.gateway.client.guilds.cache.keys) {
      if (!swyDataChildren.contains('$g.guild.json')) {
        final File dataFile = File(path.join(swyDataPath, '$g.guild.json'))..createSync();
        dataFile.writeAsStringSync('{ "join_date": "${g.timestamp.millisecondsSinceEpoch}" }');
      }
    }

    final File dataFile = File(path.join(swyDataPath, '${ev.guild.id}.guild.json'))..createSync();
    final String dataCnt = dataFile.readAsStringSync();
    final Map<String, dynamic> dataJson = jsonDecode(dataCnt);

    dataJson['guild_name'] = guild.name;
    dataJson['swy_terms_compliant'] = false;
    dataJson['swy_prefix'] = '&';

    dataFile.writeAsStringSync(jsonEncode(dataJson));
  }

  static void onGuildDelete(GuildDeleteEvent ev) async {
    final guild = await ev.guild.fetch();

    print('[>>>] [EVENT::GUILD_DELETE] Left guild ${guild.name} with id ${guild.id}');

    final String swyDataPath = Platform.environment['SWY_DATA']!;
    final Directory swyDataDir = Directory(swyDataPath);

    if (!swyDataDir.existsSync()) {
      swyDataDir.createSync(recursive: true);
    }

    final List<FileSystemEntity> swyDataEntities = swyDataDir.listSync();
    List<String> swyDataChildren = [];

    // Obtener el nombre de cada archivo
    for (final child in swyDataEntities) {
      swyDataChildren.add(child.uri.pathSegments.last);
    }

    // Crear un archivo para cada servidor si no existe
    for (final g in ev.gateway.client.guilds.cache.keys) {
      if (swyDataChildren.contains('$g.guild.json')) {
        File(path.join(swyDataPath, '$g.guild.json')).deleteSync();
      }
    }
  }

  static void onMessageDelete(MessageDeleteEvent ev) {
    if ( // Descartar el mensaje si...
      ev.guild == null || // Es un MD
      ev.deletedMessage!.author.id == ev.gateway.client.user.id || // Es un mensaje del mismo bot
      ev.deletedMessage!.applicationId is Snowflake || // Es una interaccion o webhook
      ev.deletedMessage!.poll is Poll // Tiene encuestas
    ) {
      return;
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final String swyTempDataPath = Platform.environment['SWY_TEMP']!;
    final Directory swyTempDataDir = Directory(swyTempDataPath);

    if (!swyTempDataDir.existsSync()) {
      swyTempDataDir.createSync(recursive: true);
    }

    final List<FileSystemEntity> swyTempDataEntities = swyTempDataDir.listSync();
    List<String> swyTempDataChildren = [];

    // Obtener el nombre de cada archivo
    for (final child in swyTempDataEntities) {
      swyTempDataChildren.add(child.uri.pathSegments.last);
    }

    // Crear un archivo para cada servidor si no existe
    for (final g in ev.gateway.client.guilds.cache.keys) {
      if (!swyTempDataChildren.contains('$g.guildmsgs.json')) {
        final File snipeFile = File(path.join(swyTempDataPath, '$g.guildmsgs.json'))..createSync();
        snipeFile.writeAsStringSync('{ "timestamp": "$timestamp", "main": {} }');
      }
    }

    final File snipeFile = File(path.join(swyTempDataPath, '${ev.guildId}.guildmsgs.json'));

    final String snipeCnt = snipeFile.readAsStringSync();
    Map<String, dynamic> snipeJson = jsonDecode(snipeCnt);

    List<String> attachmentUrlsList = [];

    // Si el mensaje tiene archivos adjuntos añadirlos al array
    if (ev.deletedMessage!.attachments.isNotEmpty) {
      for (final att in ev.deletedMessage!.attachments) {
        attachmentUrlsList.add(att.url.toString());
      }
    }

    // Si ya existe el canal dentro del JSON del servidor, añadir el mensaje
    if (snipeJson['main']['ch-${ev.channelId}'] is List) {
      List<dynamic> channelMsgs = snipeJson['main']['ch-${ev.channelId}'];
      channelMsgs.add(ChannelMessage(
        authorID: ev.deletedMessage!.author.id,
        authorAvatarURL: ev.deletedMessage!.author.avatar!.url,
        message: ev.deletedMessage!.content,
        attachmentCount: attachmentUrlsList.length,
        attachmentList: attachmentUrlsList,
        timestamp: (ev.deletedMessage!.timestamp.millisecondsSinceEpoch / 1000).toInt(),
      ).toMap());
    } else { // Si no, crear el array y añadirlo
      snipeJson['main']['ch-${ev.channelId}'] = [ChannelMessage(
        authorID: ev.deletedMessage!.author.id,
        authorAvatarURL: ev.deletedMessage!.author.avatar!.url,
        message: ev.deletedMessage!.content,
        attachmentCount: attachmentUrlsList.length,
        attachmentList: attachmentUrlsList,
        timestamp: (ev.deletedMessage!.timestamp.millisecondsSinceEpoch / 1000).toInt()
      ).toMap()];
    }

    snipeFile.writeAsStringSync(jsonEncode(snipeJson));
  }

  // Command Handler Plugin
  static void onCommandError(CommandsException exception) {
    if (exception.message.startsWith('Command') && exception.message.endsWith('not found')) return;

    logging.stderr.write(exception.stackTrace);
  }
}
