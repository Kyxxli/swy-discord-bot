import 'package:nyxx_commands/nyxx_commands.dart';

import 'src/commands/info/help_command.dart' show helpCommand;
import 'src/commands/utils/snipe_command.dart' show snipeCommand;
import 'src/commands/info/invite_command.dart' show inviteCommand;
import 'src/commands/utils/say_command.dart' show sayCommand;
import 'src/commands/utils/avatar_command.dart' show avatarCommand, avatarUserCommand;

void initAllCommands(CommandsPlugin commands) {
  // -- Chat Commands

  // @ Información
  commands.addCommand(helpCommand);
  commands.addCommand(inviteCommand);

  // @ Utilidad
  commands.addCommand(sayCommand);
  commands.addCommand(snipeCommand);
  commands.addCommand(avatarCommand);

  // -- User Commands

  // @ Utilidad
  commands.addCommand(avatarUserCommand);
}
