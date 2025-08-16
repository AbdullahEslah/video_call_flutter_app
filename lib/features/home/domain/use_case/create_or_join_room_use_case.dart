import 'package:stream_video/stream_video.dart';

import '../repository/call_repository.dart';

class CreateOrJoinCallUseCase {
  const CreateOrJoinCallUseCase({required this.callRepository});

  final CallRepository callRepository;

  Call createOrJoinCall({required String callID}) {
    return callRepository.createACallWithID(callID: callID);
  }
}
