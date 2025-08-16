import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key, required this.call});
  final Call call;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: StreamCallContainer(call: call),
          ),
          Expanded(
            child: StreamBuilder<CallState>(
              stream: call.state.valueStream,
              builder: (context, snapshot) {
                final state = snapshot.data ?? call.state.value;
                final participants = state.callParticipants;

                if (participants.isEmpty) {
                  return const Center(child: Text('No participants yet'));
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final p = participants[index];
                    final displayName =
                        p.name.isNotEmpty == true ? p.name : p.userId;
                    final initial =
                        (p.name.isNotEmpty == true ? p.name : p.userId)
                            .trim()
                            .characters
                            .first
                            .toUpperCase();

                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                (p.image != null && p.image!.isNotEmpty)
                                    ? NetworkImage(p.image!)
                                    : null,
                            child: (p.image == null || p.image!.isEmpty)
                                ? Text(initial)
                                : null,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            displayName,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
