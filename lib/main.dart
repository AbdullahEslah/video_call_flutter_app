import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_calling_app/features/home/presentation/provider/home_provider.dart';

import 'features/home/data/repository/call_repository_impl.dart';
import 'features/home/domain/use_case/create_client_use_case.dart';
import 'features/home/domain/use_case/create_or_join_room_use_case.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final callRepoImpl = CallRepositoryImpl();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomeProvider(
                CreateClientUseCase(callRepository: callRepoImpl),
                CreateOrJoinCallUseCase(callRepository: callRepoImpl)))
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Video Call App',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFE4D0CC),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomeScreen()),
    );
  }
}
