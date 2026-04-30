import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:al_bahrawi/app/app_constants.dart';

abstract class ChatSocketService {
  void connect(String token);
  void disconnect();
  void sendMessage(Map<String, dynamic> message);
  Stream<Map<String, dynamic>> get messagesStream;
}

class ChatSocketServiceImpl implements ChatSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messagesController =
      StreamController<Map<String, dynamic>>.broadcast();

  String? _lastToken;
  bool _isManuallyClosed = false;
  Timer? _reconnectTimer;

  @override
  Stream<Map<String, dynamic>> get messagesStream => _messagesController.stream;

  @override
  void connect(String token) {
    _lastToken = token;
    _isManuallyClosed = false;
    _establishConnection();
  }

  void _establishConnection() {
    if (_lastToken == null || _isManuallyClosed) return;

    final url = Uri.parse('${AppConstants.baseSocketUrl}?token=$_lastToken');
    log('Connecting to WebSocket: $url');

    try {
      _channel = WebSocketChannel.connect(url);
      _channel!.stream.listen(
        (data) {
          log('WebSocket received: $data');
          _messagesController.add(jsonDecode(data));
        },
        onDone: () {
          log('WebSocket connection closed.');
          _reconnect();
        },
        onError: (error) {
          log('WebSocket error: $error');
          _reconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      log('WebSocket connection failed: $e');
      _reconnect();
    }
  }

  void _reconnect() {
    if (_isManuallyClosed) return;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      log('Attempting to reconnect WebSocket...');
      _establishConnection();
    });
  }

  @override
  void disconnect() {
    _isManuallyClosed = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    log('WebSocket manually disconnected.');
  }

  @override
  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      log('WebSocket sending: $message');
      _channel!.sink.add(jsonEncode(message));
    } else {
      log('WebSocket not connected. Cannot send message.');
    }
  }
}
