import 'package:flutter/material.dart';
import 'package:sample/services/signInHandler.dart';

class DrawerLogoutButton extends StatefulWidget {
  const DrawerLogoutButton({Key? key});

  @override
  State<DrawerLogoutButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<DrawerLogoutButton> {
  late SignInHandler _googleSignInHandler;

  @override
  void initState() {
    super.initState();
    _googleSignInHandler = SignInHandler(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              _googleSignInHandler.auth.currentUser!.displayName!,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const Icon(Icons.exit_to_app, color: Colors.white70),
        ],
      ),
      onTap: () {
        // Exibe o popup de confirmação
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Logout confirmation"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () {
                    
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
                TextButton(
                  onPressed: () {
                  
                    _googleSignInHandler.signInWithGoogle();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes, logout"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
