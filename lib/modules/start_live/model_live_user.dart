// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

class UserName {
  UserName({
    this.username,
    this.micMuted,
    this.watch,
    this.videoMuted,
  });

  String? username;
  bool? micMuted;
  bool? videoMuted;
  bool? watch;
}

class RTCSessionDescriptionSerializer {
  Map<String, dynamic> serialize(RTCSessionDescription? sessionDescription) {
    return {
      'type': sessionDescription?.type,
      'sdp': sessionDescription?.sdp,
    };
  }
}
