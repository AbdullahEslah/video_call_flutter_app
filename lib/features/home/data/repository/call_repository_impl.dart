import 'package:stream_video/stream_video.dart';

import '../../domain/repository/call_repository.dart';

class CallRepositoryImpl implements CallRepository {
  @override
  StreamVideo createClientForVideoCall(
      {required String accessToken,
      required String apiKey,
      required String userID,
      required String role,
      required String name}) {
    final client = StreamVideo(apiKey,
        user: User.regular(userId: userID, role: role, name: name),
        // userToken:
        // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL0RlZGljYXRlZF9XaGl0ZWZpc2giLCJ1c2VyX2lkIjoiRGVkaWNhdGVkX1doaXRlZmlzaCIsInZhbGlkaXR5X2luX3NlY29uZHMiOjYwNDgwMCwiaWF0IjoxNzU1MzE4OTA2LCJleHAiOjE3NTU5MjM3MDZ9.TWKrizfhn3Eg_ps-1TpjuBB6UDrGub4zNZ5XOhTN-Ss',
        userToken: accessToken);

    // if result wasn't successful, then result will return null
//     final userToken = result.getDataOrNull();
//     final userInfo = client.currentUser;
    return client;
    // return
  }

  @override
  Call createACallWithID({required String callID}) {
    return StreamVideo.instance.makeCall(
      callType: StreamCallType.defaultType(),
      id: callID,
    );
  }
}
