import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:dotenv/dotenv.dart';

// Cargar todos los comandos
import 'package:swyvi_discord_bot/swyvi_discord_bot.dart';
import 'package:swyvi_discord_bot/swyvi_event_handlers.dart';

void main() async {
  final environ = DotEnv(includePlatformEnvironment: true)..load();

  CommandsPlugin commands = CommandsPlugin(
    prefix: (MessageCreateEvent ev) {
      return '&';
    },

    guild: Snowflake.parse(environ['SWY_TEST_GUILD'] as String),

    options: CommandsOptions(
      logErrors: false,
      type: CommandType.slashOnly
    )
  );

  // Add all commands
  initAllCommands(commands);

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

  EventHandlers()
    ..listenBot(bot)
    ..listenCommandPlugin(commands);
}
