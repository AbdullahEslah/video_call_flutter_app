import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../../domain/entity/user_entity.dart';
import '../../domain/use_case/create_client_use_case.dart';
import '../../domain/use_case/create_or_join_room_use_case.dart';
import '../home_enum_state/client_enum_state.dart';
import '../home_enum_state/join_call_enum_state.dart';
import 'package:http/http.dart' as http;

class HomeProvider with ChangeNotifier {
  final CreateClientUseCase createClientUseCase;
  final CreateOrJoinCallUseCase createOrJoinRoomUseCase;
  HomeProvider(this.createClientUseCase, this.createOrJoinRoomUseCase);

  final TextEditingController _nameTextEditingController =
      TextEditingController();
  TextEditingController? get nameTextEditingController =>
      _nameTextEditingController;

  UserEntity? _user;
  UserEntity? get user => _user;

  StreamVideo? _client;
  StreamVideo? get client => _client;

  Call? _call;
  Call? get call => _call;

  /// responsible for showing errorMessage
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  /// responsible for loading, failure or success state
  ClientEnumState _clientEnumState = ClientEnumState.normal;
  ClientEnumState get clientEnumState => _clientEnumState;

  JoinCallEnumState _joinCallEnumState = JoinCallEnumState.normal;
  JoinCallEnumState get joinCallEnumState => _joinCallEnumState;

  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  ///**********************************

  ///  update main screens state
  void setClientState(ClientEnumState state) {
    _clientEnumState = state;
    notifyListeners();
  }

  // Reset screen to normal state
  void resetClientState() {
    _clientEnumState = ClientEnumState.normal;
    notifyListeners();
  }

  void setJoiningCallState(JoinCallEnumState state) {
    _joinCallEnumState = state;
    notifyListeners();
  }

  // Reset screen to normal state
  void resetJoiningCallState() {
    _joinCallEnumState = JoinCallEnumState.normal;
    notifyListeners();
  }

  ///*************************

  void updateNameTextField(String name) {
    _nameTextEditingController.text = name;
    notifyListeners();
  }

  void updateUserData() {
    _user?.name = _nameTextEditingController.text;
    _user?.userId =
        "${_nameTextEditingController.text}_withRandomID_${Random().nextInt(1000)}";
    _user?.role = "user";
    notifyListeners();
  }

  void resetUser() {
    _user?.name = null;
    _user?.userId = null;
    _user?.role = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getToken(String userId) async {
    final url =
        Uri.parse("https://videocallapi-production.up.railway.app/get_token");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // هيكون فيه user_id, token, api_key
      } else {
        print('Failed to fetch token: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching token: $e');
      return null;
    }
  }

  void createClient() async {
    setClientState(ClientEnumState.loading);
    Future.delayed(Duration(seconds: 2));
    // const apiKey = "qcn666ttrhvb";
    const apiKey = "qcn666ttrhvb";
    // const String userId = "abdallah";
    final String userId =
        "${_nameTextEditingController.text}_${Random().nextInt(1000)}";
    final data = await getToken(userId);
    String? token;
    if (data != null) {
      token = data["token"];
    } else {
      token = null;
      return;
    }
    try {
      await StreamVideo.reset();
      final result = createClientUseCase.createClient(
          accessToken: token ?? "",
          apiKey: apiKey,
          userID: userId,
          role: "admin",
          name: _user?.name ?? "");
      _client = result;
      // final connectResult = await result.connect();
      // if (connectResult.isSuccess) {
      //   debugPrint("✅ Client connected as guest: ${result.currentUser}");
      // }
      // else {
      //   debugPrint("❌ Failed to connect: ${connectResult.}");
      // }
      // await result.connect().then((accessToken) {
      //   final userToken = accessToken.getDataOrNull();
      //   debugPrint("user token after initializing client is $userToken");
      // });
      setClientState(ClientEnumState.success);
    } catch (e) {
      debugPrint("error happened while creating client $e");
      setError("$e");
      setClientState(ClientEnumState.error);
    }
  }

  Future<void> createOrGetVideoCall() async {
    setJoiningCallState(JoinCallEnumState.loading);
    Future.delayed(Duration(seconds: 2));
    try {
      const String callId = "Abdallah_Call_id";
      _call = createOrJoinRoomUseCase.createOrJoinCall(callID: callId);
      await _call?.getOrCreate();
      setJoiningCallState(JoinCallEnumState.success);
    } catch (e) {
      debugPrint("error happened while joining call $e");
      setError("$e");
      setJoiningCallState(JoinCallEnumState.error);
    }
  }
}
