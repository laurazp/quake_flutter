/// Mirrors Quake/Entities/MessageType.swift.
enum MessageType {
  request,
  bugReport,
  question,
  other;

  String get label {
    switch (this) {
      case MessageType.request:
        return 'Request';
      case MessageType.bugReport:
        return 'Bug Report';
      case MessageType.question:
        return 'Question';
      case MessageType.other:
        return 'Other';
    }
  }
}
