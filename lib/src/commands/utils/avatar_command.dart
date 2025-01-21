import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:swyvi_discord_bot/src/utils/avatar_formatting.dart';
import 'package:swyvi_discord_bot/src/utils/get_random_color.dart';

ChatCommand avatarCommand = ChatCommand(
  'avatar',
  'Muestra en grande el avatar/foto de perfil tuyo o de otro usuario.',
  id('avatar', (
    ChatContext context, [
      @Name('usuario') @Description('El usuario en cuestión.')
      User? user
    ]
  ) async {
    var [r, g, b] = getRandomPastelColor();

    if (user == null) {
      Uri avPng = formatAvatar(context.user.avatar, 2048, CdnFormat.png);
      Uri avJpg = formatAvatar(context.user.avatar, 2048, CdnFormat.jpeg);
      Uri avWebp = formatAvatar(context.user.avatar, 2048, CdnFormat.webp);
      Uri avGif = formatAvatar(context.user.avatar, 2048, CdnFormat.gif);

      EmbedBuilder myAvatarEmbed = EmbedBuilder(
        author: EmbedAuthorBuilder(
          name: 'Swy~vi!',
          iconUrl: (await context.client.user.fetch()).avatar.url
        ),
        title: 'Avatar de ${context.user.globalName ?? context.user.username}',
        description: '[**PNG**]($avPng) \u2507 [**JPEG**]($avJpg) \u2507 [**WEBP**]($avWebp)',
        image: EmbedImageBuilder(
          url: context.user.avatar.isAnimated ? avGif : avPng
        ),
        footer: EmbedFooterBuilder(
          text: 'Solicitado por ${context.user.globalName ?? context.user.username}',
          iconUrl: context.user.avatar.url
        ),
        color: DiscordColor.fromRgb(r, g, b)
      );

      context.respond(MessageBuilder(
        embeds: [myAvatarEmbed]
      ));
    } else if (context.arguments.first is User) {
      Uri avPng = formatAvatar(user.avatar, 2048, CdnFormat.png);
      Uri avJpg = formatAvatar(user.avatar, 2048, CdnFormat.jpeg);
      Uri avWebp = formatAvatar(user.avatar, 2048, CdnFormat.webp);
      Uri avGif = formatAvatar(user.avatar, 2048, CdnFormat.gif);

      EmbedBuilder avatarEmbed = EmbedBuilder(
        author: EmbedAuthorBuilder(
          name: 'Swy~vi!',
          iconUrl: (await context.client.user.fetch()).avatar.url
        ),
        title: 'Avatar de ${user.globalName ?? user.username}',
        description: '[**PNG**]($avPng) \u2507 [**JPEG**]($avJpg) \u2507 [**WEBP**]($avWebp)',
        image: EmbedImageBuilder(
          url: user.avatar.isAnimated ? avGif : avPng
        ),
        footer: EmbedFooterBuilder(
          text: 'Solicitado por ${context.user.globalName ?? context.user.username}',
          iconUrl: context.user.avatar.url
        ),
        color: DiscordColor.fromRgb(r, g, b)
      );

      context.respond(MessageBuilder(
        embeds: [avatarEmbed]
      ));
    } else {
      context.respond(MessageBuilder(
        content: 'Usuario inválido'
      ));
    }
  })
);

UserCommand avatarUserCommand = UserCommand(
  'Ver avatar',
  id('u#avatar', (UserContext context) async {
    Uri avPng = formatAvatar(context.targetUser.avatar, 2048, CdnFormat.png);
    Uri avJpg = formatAvatar(context.targetUser.avatar, 2048, CdnFormat.jpeg);
    Uri avWebp = formatAvatar(context.targetUser.avatar, 2048, CdnFormat.webp);
    Uri avGif = formatAvatar(context.targetUser.avatar, 2048, CdnFormat.gif);

    var [r, g, b] = getRandomPastelColor();

    EmbedBuilder avatarEmbed = EmbedBuilder(
        author: EmbedAuthorBuilder(
          name: 'Swy~vi!',
          iconUrl: (await context.client.user.fetch()).avatar.url
        ),
        title: 'Avatar de ${context.targetUser.globalName ?? context.targetUser.username}',
        description: '[**PNG**]($avPng) \u2507 [**JPEG**]($avJpg) \u2507 [**WEBP**]($avWebp)',
        image: EmbedImageBuilder(
          url: context.targetUser.avatar.isAnimated ? avGif : avPng
        ),
        footer: EmbedFooterBuilder(
          text: 'Solicitado por ${context.user.globalName ?? context.user.username}',
          iconUrl: context.user.avatar.url
        ),
        color: DiscordColor.fromRgb(r, g, b)
      );

      context.respond(MessageBuilder(
        embeds: [avatarEmbed],
      ));
  })
);
