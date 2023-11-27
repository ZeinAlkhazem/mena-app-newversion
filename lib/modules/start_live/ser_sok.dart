// Package imports:
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SignallingService {
  var logger = Logger();

  late Socket socket;

  SignallingService._privateConstructor();

  static final SignallingService instance =
      SignallingService._privateConstructor();

  void init({
    required String websocketUrl,
    List<String>? transports,
    Map<String, dynamic>? extraHeaders,
  }) {
    final options = OptionBuilder()
        .setTransports(transports ?? ['websocket'])
        .setExtraHeaders(extraHeaders ?? {})
        .build();

    socket = io(websocketUrl, options);

    socket
      ..on('connect', (_) {
        logger.w('>>>>>>>>>>>>>>>>>>>>>>Socket connected !!');
        logger.d('Socket connected !!');
        logger.v('>>>>>>>>>>>>>>>>>>>>>>Socket connected !!');
      })
      ..on('connect_error', (data) {
        logger.w('Connect Error $data');
      })

      // Error handling for connection
      ..on('error', (error) {
        logger.w('Socket Error: $error');
      })

      // Error handling for disconnection
      ..on('disconnect', (_) {
        logger.w('Socket disconnected');
      })

      // Connect socket
      ..connect();
  }
}
