import 'package:stream_video/stream_video.dart';

import '../repository/call_repository.dart';

class CreateClientUseCase {
  const CreateClientUseCase({required this.callRepository});

  final CallRepository callRepository;

  StreamVideo createClient(
      {required String accessToken,
      required String apiKey,
      required String userID,
      required String role,
      required String name}) {
    return callRepository.createClientForVideoCall(
        accessToken: accessToken,
        apiKey: apiKey,
        userID: userID,
        role: role,
        name: name);
  }
}
