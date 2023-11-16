import 'package:flutter/material.dart';
import 'package:sample/services/google_sign_in.dart';

class DrawerLogoutButton extends StatefulWidget {
  const DrawerLogoutButton({super.key});

  @override
  State<DrawerLogoutButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<DrawerLogoutButton> {
  late GoogleSignInHandler _googleSignInHandler;

  @override
  void initState() {
    super.initState();
    _googleSignInHandler = GoogleSignInHandler(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(_googleSignInHandler.auth.currentUser!.displayName!,
                style: const TextStyle(color: Colors.white70)
            ),
          ),
          const Icon(Icons.exit_to_app, color: Colors.white70),
        ],
      ),
      onTap: () {
        Future.delayed(const Duration(milliseconds: 200), () {
          _googleSignInHandler.signInWithGoogle();
        });
      },
    );
  }
}