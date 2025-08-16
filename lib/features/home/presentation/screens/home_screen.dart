import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_calling_app/features/home/presentation/provider/home_provider.dart';
import 'package:video_calling_app/features/home/presentation/screens/join_call_screen.dart';

import '../../../../custom_widgets/custom_text_form_field.dart';
import '../home_enum_state/client_enum_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static final GlobalKey<FormState> mainWidgetFormKey = GlobalKey<FormState>();

  SingleChildScrollView buildUserFields(
      HomeProvider homeProvider, BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: Form(
        key: mainWidgetFormKey,
        child: Padding(
          padding: EdgeInsets.only(
              left: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              right: 16),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  "Name",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              CustomTextFieldForm(
                controller: homeProvider.nameTextEditingController,
                onChanged: (fromChanged) {
                  homeProvider.updateNameTextField(fromChanged);
                  homeProvider.updateUserData();
                },
                keyboardType: TextInputType.name,
                placeholder: "Name",
                emptyValueText: 'Please type your name',
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s'))
                ],
                // focus: nameFocus,
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: () {
                  if (mainWidgetFormKey.currentState?.validate() ?? false) {
                    /// register after validation
                    homeProvider.createClient();
                  }
                },
                child: Text(
                  "Create Your Profile",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget loadWidget(HomeProvider homeProvider, BuildContext context) {
    switch (homeProvider.clientEnumState) {
      case ClientEnumState.normal:
        return buildUserFields(homeProvider, context);

      case ClientEnumState.loading:
        (Platform.isIOS)
            ? Center(
                child: CupertinoActivityIndicator(
                    color: Colors.black54, radius: 15))
            : const Center(
                child: CircularProgressIndicator(color: Colors.black54),
              );

      case ClientEnumState.success:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          (Platform.isIOS)
              ? Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => JoinCallScreen()),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinCallScreen()),
                );
          homeProvider.resetClientState();
          homeProvider.resetUser();
        });

      case ClientEnumState.error:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                homeProvider.errorMessage ?? "",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
          homeProvider.resetClientState();
        });
        break;
    }
    return buildUserFields(homeProvider, context);
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome To Video Call App",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: loadWidget(homeProvider, context),
      ),
    );
  }
}
