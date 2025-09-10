import 'dart:convert';
import 'dart:io';

import 'package:class_websocket_flutter/data/dtos/chat_message_dto.dart';
import 'package:class_websocket_flutter/data/models/chat_message.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

// 웹 소켓 네트워크만 담당
// 어떤 기능이 필요한가?
// 스톰프 클라이언트 초기화 처리
// 연결 성공 처리
// 연결 해제 처리
// 메세지 전송 처리
// 메세지 수신 처리
// 에러 처리 등
class ChatRepository {
  late StompClient stompClient;

  // 플랫폼별 서버 주소 설정
  static String get serverUrl {
    if (Platform.isAndroid) {
      return 'http://192.168.0.132:8080';
      // 'http://10.0.2.2:8080'
      // http://192.168.0.132:8080
    } else if (Platform.isIOS) {
      return 'http://localhost:8080';
    } else {
      return 'http://localhost:8080';
    }
  }

  // 연결 상태 확인 getter
  bool get isConnected => stompClient.connected;

  // 콜백 함수 만들기
  // 네트워크에서 받아낸 이벤트를 상위 클래스에 알려주기 위함
  // ChatRepository 목적은 네트워크 통신을 통해서 무슨 이벤트만 들어 왔는지만 알면 되고
  // 위 알림을 바탕으로 어떻게 처리할지는 상위 클래스가 결정 ...
  void Function()? onConnected;
  void Function()? onDisconnected;
  void Function(String error)? onError;
  void Function(ChatMessage message)? onMessage;

  // 스톰프 클라이언트 초기화
  void init() {
    stompClient = StompClient(
      config: StompConfig(
        url: '$serverUrl/ws',
        onConnect: _handleConnected,
        onDisconnect: _handleDisconnected,
        onWebSocketError: (error) => onError?.call('연결 오류: $error'),
        useSockJS: true, // 호환성 때문에 열어둠
      ),
    );
  }

  // StompFrame --> 스톰프 클라이언트가 가지고 있음
  // frame.body    (편지 내용)
  // frame.headers (받는 사람 주소, 보내는 사람 주소, 배송 옵션)
  // frame.command (일반 우편, 등기 우편, 택배)
  void _handleConnected(StompFrame frame) {
    print("웹 소켓 핸드 쉐이크 성공");
    // 연결 성공 시 == 어떤 메세지를 구독할지 바로 호출
    _subscribeToMessage(); // 선이 연결된 상태니까 그 중 나는 /topic/messge만 받겠다
    onConnected?.call();
  }

  void _handleDisconnected(StompFrame frame) {
    onDisconnected?.call();
  }

  // 서버 연결
  void connect() {
    stompClient.activate();
  }

  // 연결 해제
  void disconnect() {
    if (stompClient.connected) {
      stompClient.deactivate();
    }
  }

  // 메세지 전송
  void sendMessage(ChatMessage message) {
    if (stompClient.connected == false) {
      onError?.call('웹 소켓 서버와 연결 안됨');
      return;
    }

    final ChatMessageDto dto = ChatMessageDto.fromModel(message);
    final String jsonBody = jsonEncode(dto);

    stompClient.send(
      destination: '/app/chat',
      body: jsonBody,
    );
  }

  // 메세지 구독
  void _subscribeToMessage() {
    print("서버에 /topic/message 구독 완료");
    stompClient.subscribe(
      destination: '/topic/message',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          // 메세지 수신 처리
          _handleIncomingMessage(frame.body!);
        }
      },
    );
  }

  void _handleIncomingMessage(String messageBody) {
    try {
      print("들어온 메세지 확인 : ${messageBody}");
      final jsonData = jsonDecode(messageBody);
      final dto = ChatMessageDto.fromJson(jsonData);
      final ChatMessage message = dto.toModel();
      onMessage?.call(message);
    } catch (e) {
      print("에러 확인 : ${e.toString()}");
    }
  }
}
