import 'package:nyxx/nyxx.dart';

class ChannelMessage {
  Snowflake? authorID;
  Uri? authorAvatarURL;
  String? message;
  int? attachmentCount;
  List? attachmentList;

  ChannelMessage({
    required this.authorID,
    required this.authorAvatarURL,
    required this.message,
    required this.attachmentCount,
    required this.attachmentList
  });

  Map<String, dynamic> toMap() {
    return {
      'authorID': authorID!.value,
      'authorAvatarURL': authorAvatarURL.toString(),
      'message': message.toString(),
      'attachmentCount': attachmentCount,
      'attachmentList': attachmentList
    };
  }

  static ChannelMessage fromMap(Map<String, dynamic> map) {
    return ChannelMessage(
      authorID: Snowflake(map['authorID']),
      authorAvatarURL: Uri.parse(map['authorAvatarURL']),
      message: map['message'],
      attachmentCount: map['attachmentCount'],
      attachmentList: map['attachmentList']
    );
  }
}
