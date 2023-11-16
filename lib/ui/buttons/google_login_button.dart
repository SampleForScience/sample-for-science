import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sample/services/google_sign_in.dart';

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  State<GoogleLoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<GoogleLoginButton> {
  late GoogleSignInHandler _googleSignInHandler;

  @override
  void initState() {
    super.initState();
    _googleSignInHandler = GoogleSignInHandler(context);
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
      onPressed: _googleSignInHandler.signInWithGoogle,
      child: const SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(FontAwesomeIcons.google),
            SizedBox(width: 15,),
            Text("Sign in with Google",
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
