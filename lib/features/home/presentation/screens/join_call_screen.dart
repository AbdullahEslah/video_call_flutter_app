import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_calling_app/features/home/presentation/provider/home_provider.dart';
import 'package:video_calling_app/features/home/presentation/screens/video_call_screen.dart';

import '../home_enum_state/join_call_enum_state.dart';

class JoinCallScreen extends StatelessWidget {
  const JoinCallScreen({super.key});

  Widget loadWidget(HomeProvider homeProvider, BuildContext context) {
    switch (homeProvider.joinCallEnumState) {
      case JoinCallEnumState.normal:
        return createMainWidget(homeProvider, context);

      case JoinCallEnumState.loading:
        (Platform.isIOS)
            ? Center(
                child: CupertinoActivityIndicator(
                    color: Colors.black54, radius: 15))
            : const Center(
                child: CircularProgressIndicator(color: Colors.black54),
              );

      case JoinCallEnumState.success:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          (Platform.isIOS)
              ? Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => VideoCallScreen(
                            call: homeProvider.call!,
                          )),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoCallScreen(
                            call: homeProvider.call!,
                          )),
                );
          homeProvider.resetJoiningCallState();
        });

      case JoinCallEnumState.error:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                homeProvider.errorMessage ?? "",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
          homeProvider.resetJoiningCallState();
        });
        break;
    }
    return createMainWidget(homeProvider, context);
  }

  Padding createMainWidget(HomeProvider homeProvider, BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: ElevatedButton(
              onPressed: () {
                homeProvider.createOrGetVideoCall();
                // (Platform.isIOS)
                //     ? Navigator.push(
                //         context,
                //         CupertinoPageRoute(
                //             builder: (context) => VideoCallScreen(
                //                   call: homeProvider.call!,
                //                 )),
                //       )
                //     : Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => VideoCallScreen(
                //                   call: homeProvider.call!,
                //                 )),
                //       );
              },
              child: Text(
                "Join Video Call Now",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Join The Video Call"),
      ),
      body: loadWidget(homeProvider, context),
    );
  }
}
