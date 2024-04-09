import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sample/services/signInHandler.dart';

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  State<GoogleLoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<GoogleLoginButton> {
  late SignInHandler _signInHandler;

  @override
  void initState() {
    super.initState();
    _signInHandler = SignInHandler(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 325,
        height: 48,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(43, 52, 70, 1),
                Color.fromRGBO(88, 131, 158, 1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(-2, 2),
                blurRadius: 4,
                spreadRadius: 2,
              )
            ]),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.google),
              SizedBox(width: 24),
              Text(
                "Login with Google",
                style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(202, 207, 203, 1),
                    fontFamily: 'AvenirRoman'),
              ),
            ],
          ),
        ),
      ),
      onTap: _signInHandler.signInWithGoogle,
    );
  }
}
