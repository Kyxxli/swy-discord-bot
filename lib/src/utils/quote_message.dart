String quote(String author, String message, bool useQuoteBlock) {
  return '${useQuoteBlock ? '>>> ' : null}**$author**\n$message';
}
