import 'package:nyxx/nyxx.dart';

class ChannelMessage {
  Snowflake? authorID;
  Uri? authorAvatarURL;
  String? message;
  int? attachmentCount;
  List? attachmentList;
  int? timestamp;
  String? channelName;

  ChannelMessage({
    required this.authorID,
    required this.authorAvatarURL,
    required this.message,
    required this.attachmentCount,
    required this.attachmentList,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorID': authorID!.value,
      'authorAvatarURL': authorAvatarURL.toString(),
      'message': message.toString(),
      'attachmentCount': attachmentCount,
      'attachmentList': attachmentList,
      'timestamp': timestamp,
    };
  }

  static ChannelMessage fromMap(Map<String, dynamic> map) {
    return ChannelMessage(
      authorID: Snowflake(map['authorID']),
      authorAvatarURL: Uri.parse(map['authorAvatarURL']),
      message: map['message'],
      attachmentCount: map['attachmentCount'],
      attachmentList: map['attachmentList'],
      timestamp: map['timestamp'],
    );
  }
}
