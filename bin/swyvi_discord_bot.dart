// import 'dart:io';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:dotenv/dotenv.dart';
import 'package:logger/logger.dart' as l;

// Load all commands
import 'package:swyvi_discord_bot/swyvi_discord_bot.dart';

void main() async {
  final environ = DotEnv(includePlatformEnvironment: true)..load();
  final logger = l.Logger();

  CommandsPlugin commands = CommandsPlugin(
    prefix: (MessageCreateEvent ev) {
      return '&';
    },

    guild: Snowflake.parse(environ['SWY_TEST_GUILD'] as String),

    options: CommandsOptions(
      logErrors: true
    )
  );

  final swyClient = await Nyxx.connectGateway(
    environ['SWY_AUTH_SECRET'] as String,
    GatewayIntents.all,
    options: GatewayClientOptions(
      plugins: [commands, logging]
    )
  );

  final swyUser = await swyClient.users.fetchCurrentUser();

  swyClient.onReady.listen((ReadyEvent e) {
    logger.i('Swy~vi is connected to the Discord gateway!');
    logger.d('Connected as ${swyUser.username}');
  });

  // Add all commands
  commands.addCommand(helpCommand);
}
