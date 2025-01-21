import 'package:nyxx/nyxx.dart';

Uri formatAvatar(CdnAsset avatar, int? size, CdnFormat? format) {
  String formatSanitized =
    format == CdnFormat.webp
    ? 'webp' :
    format == CdnFormat.png
    ? 'png' :
    format == CdnFormat.jpeg
    ? 'jpeg' :
    format == CdnFormat.gif ? 'gif'
    : 'png';

  return Uri.parse(
    'https://cdn.discordapp.com${avatar.base.toString()}/${avatar.hash}.$formatSanitized'
    '${size is int ? '?size=$size' : ''}'
  );
}
