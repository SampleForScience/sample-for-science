import 'package:flutter/material.dart';
import 'package:sample/services/signInHandler.dart';
import 'package:sign_in_button/sign_in_button.dart';

class AppleLoginButton extends StatefulWidget {
  const AppleLoginButton({super.key});

  @override
  State<AppleLoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<AppleLoginButton> {
  late SignInHandler _signInHandler;

  @override
  void initState() {
    super.initState();
    _signInHandler = SignInHandler(context);
  }

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.appleDark,
      text: "Login with Apple",
      onPressed: _signInHandler.signInWithApple,
    );
  }
}
