import 'package:flutter/material.dart';
import 'package:sample/services/signInHandler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              FaIcon(FontAwesomeIcons.apple, color: Colors.white),
              SizedBox(width: 24),
              Text(
                "Login with Apple",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        // await showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: const Text("Email Sharing"),
        //       content: const Text("For your account to be successfully created, you need to share your email on the first login"),
        //       actions: [
        //         TextButton(
        //           child: const Text("OK"),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );

        _signInHandler.signInWithApple();
      },
    );
  }
}
