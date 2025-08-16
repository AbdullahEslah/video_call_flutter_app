import 'package:stream_video/stream_video.dart';

abstract class CallRepository {
  StreamVideo createClientForVideoCall(
      {required String accessToken,
      required String apiKey,
      required String userID,
      required String role,
      required String name});

  Call createACallWithID({required String callID});
}
