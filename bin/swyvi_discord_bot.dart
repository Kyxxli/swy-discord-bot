import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:dotenv/dotenv.dart';
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
      logErrors: true,
    )
  );

  await Nyxx.connectGateway(
    environ['SWY_AUTH_SECRET'] as String,
    GatewayIntents.all,
    options: GatewayClientOptions(
      plugins: [
        commands,
        logging,
        ignoreExceptions,
      ]
    )
  );

  // Add all commands
  commands.addCommand(helpCommand);
}
