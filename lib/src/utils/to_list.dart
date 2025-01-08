String toOrderedTextList(List data) {
  String outString = '';

  for (int i = 0;i < data.length;i++) {
    outString += '$i. ${data[i]}\n';
  }

  return outString;
}

String toUnorderedTextList(List data) {
  String outString = '';

  for (int i = 0;i < data.length;i++) {
    outString += '- ${data[i]}\n';
  }

  return outString;
}
