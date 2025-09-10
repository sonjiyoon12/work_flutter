enum MessageType { CHAT, SYSTEM }

class ChatMessage {
  final String id;
  final String content;
  final String sender;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  // 일반 채팅 메시지 생성자
  factory ChatMessage.createChat({
    required String content,
    required String sender,
  }) {
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: content,
      sender: sender.trim(),
      type: MessageType.CHAT,
      timestamp: DateTime.now(),
    );
  }

  // 시스템 메시지 생성
  factory ChatMessage.createSystem({
    String? content,
  }) {
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: content ?? '',
      sender: 'SYSTEM',
      type: MessageType.SYSTEM,
      timestamp: DateTime.now(),
    );
  }

  // 시간 포맷팅 기능
  String get formattedTime {
    // 시간 2자리 수 (08), (11), 자동으로 붙여서 만들어 내. 9 -> 09
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // 시스템 메세지 여부
  bool get isSystemMessage {
    return type == MessageType.SYSTEM;
  }

  // 내 메세지 여부 (UI 확인용)
  bool isMyMessage(String currentUsername) {
    if (isSystemMessage) return false;
    return sender == currentUsername;
  }

  // 읽음 처리(불변 객체이므로 새 인스턴스 생성)
  ChatMessage markAsRead() {
    return ChatMessage(
      id: id,
      content: content,
      sender: sender,
      type: type,
      timestamp: timestamp,
      isRead: true,
    );
  }
}
