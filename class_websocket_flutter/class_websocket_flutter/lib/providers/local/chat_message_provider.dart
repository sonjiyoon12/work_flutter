// 창고 데이터
import 'package:class_websocket_flutter/data/models/chat_message.dart';
import 'package:class_websocket_flutter/data/repository/chat_repository.dart';
import 'package:class_websocket_flutter/providers/local/connection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_message_provider.dart';

class ChatState {
  final List<ChatMessage> messages;
  final String username;

  ChatState({required this.messages, required this.username});

  ChatState copyWith({List<ChatMessage>? messages, String? username}) {
    return ChatState(
        messages: messages ?? this.messages,
        username: username ?? this.username);
  }
}

// 창고 매뉴얼
class ChatMessageNotifier extends Notifier<ChatState> {
  late ChatRepository _chatRepository;

  @override
  ChatState build() {
    final connectionNotifier = ref.watch(connectedStateProvider.notifier);
    _chatRepository = connectionNotifier.chatRepository;
    _setupMessageCallBack(); // 콜백 메서드 등록 처리

    return ChatState(
        messages: [ChatMessage.createSystem(content: "채팅이 시작 되었습니다")],
        username: "d");
  }

  void _setupMessageCallBack() {
    _chatRepository.onMessage = (messageBody) {
      // 디버그 용
      print("메세지 수신 됨 : ${messageBody.content} ${messageBody.sender}");

      if (messageBody.sender == state.username) {
        // 내 메세지의 브로드캐스트는 무시
        return;
      }

      // 새로운 ChatMessage 객체가 들어 왔다면 내 변수 List<ChatMessage> 에 추가 해줘야
      // UI 화면을 재갱신 처리 한다(자동)
      // 스프레드 연산자 사용
      state = state.copyWith(messages: [...state.messages, messageBody]);
    };
    // TODO 필요 하다면 구현
    // _chatRepository.onError
    // _chatRepository.onDisconnected
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) {
      return;
    }

    ChatMessage message =
        ChatMessage.createChat(content: content, sender: state.username);

    // 메세지 수신측 콜백 메서드에 내가 발송한 메세지는 무시 처리 해둠
    // 상태 변경 --> UI watch 할 예정이기 때문에 자동으로 UI 업데이트 됨
    state = state.copyWith(messages: [...state.messages, message]);

    // 서버로 전송 하기
    _chatRepository.sendMessage(message);
  }

  // TODO - 추가 비즈니스 로직 설계 (사용자명 변경 또는 내 메세지 삭제)
}

// 창고 개설
final chatMessageProvider = NotifierProvider<ChatMessageNotifier, ChatState>(
    () => ChatMessageNotifier());
