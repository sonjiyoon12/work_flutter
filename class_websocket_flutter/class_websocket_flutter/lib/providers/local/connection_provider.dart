// 창고 데이터
import 'package:class_websocket_flutter/data/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/chat_repository.dart';

class ConnectionState {
  final bool isConnected;
  final String status;

  ConnectionState({required this.isConnected, required this.status});

  ConnectionState copyWith({bool? isConnected, String? status}) {
    return ConnectionState(
      isConnected: isConnected ?? this.isConnected,
      status: status ?? this.status,
    );
  }
} // end of ConnectionState

// 창고 매뉴얼 (확장된 VM 개념)
class ConnectionStateNotifier extends Notifier<ConnectionState> {
  late ChatRepository _chatRepository;

  // _chatRepository getter 메서드 만들기
  ChatRepository get chatRepository => _chatRepository;

  @override
  ConnectionState build() {
    _chatRepository = ChatRepository();
    _setupCallbacks();
    _chatRepository.init();

    return ConnectionState(isConnected: false, status: "연결 준비중");
  }

  void _setupCallbacks() {
    _chatRepository.onConnected = () {
      state = state.copyWith(isConnected: true, status: "연결됨");
    };

    _chatRepository.onDisconnected = () {
      state = state.copyWith(isConnected: false, status: "연결 해제됨");
    };

    _chatRepository.onError = (error) {
      state = state.copyWith(isConnected: false, status: '$error');
    };
  }

  // 연결 시작
  void connect() {
    state = state.copyWith(status: "연결 중...");
    _chatRepository.connect();
  }

  // 연결 해제
  void disconnected() {
    state = state.copyWith(status: "연결 해제중...");
    _chatRepository.disconnect();
  }
}

// 실제 창고 개설
final connectedStateProvider =
    NotifierProvider<ConnectionStateNotifier, ConnectionState>(
  () => ConnectionStateNotifier(),
);
