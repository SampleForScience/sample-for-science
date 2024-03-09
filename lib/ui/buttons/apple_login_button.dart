import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sample/services/apple_sign_in.dart';

class AppleLoginButton extends StatefulWidget {
  const AppleLoginButton({super.key});

  @override
  State<AppleLoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<AppleLoginButton> {
  late AppleSignInHandler _appleSignInHandler;

  @override
  void initState() {
    super.initState();
    _appleSignInHandler = AppleSignInHandler(context);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Define o raio das bordas
        ),
      ),
      onPressed: _appleSignInHandler.signInWithApple,
      child: const SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(FontAwesomeIcons.apple),
            SizedBox(width: 15,),
            Text("Login with Apple",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500
              )
            ),
          ],
        ),
      ),
    );
  }
}
