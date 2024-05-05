import 'package:flutter/material.dart';
import 'package:sample/services/signInHandler.dart';

// Itens do popMenuButton
enum MenuItem { login, registration }

class CircularAvatarButton extends StatefulWidget {
  const CircularAvatarButton({super.key});

  @override
  State<CircularAvatarButton> createState() => _CircularAvatarButtonState();
}

class _CircularAvatarButtonState extends State<CircularAvatarButton> {
  late SignInHandler _googleSignInHandler;
  late bool isLogged;

  @override
  void initState() {
    super.initState();
    _googleSignInHandler = SignInHandler(context);
    setState(() {
      if (_googleSignInHandler.auth.currentUser != null) {
        isLogged = true;
      } else {
        isLogged = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
        onSelected: (MenuItem item) async {
          if (item == MenuItem.login) {
            try {
              await _googleSignInHandler.signInWithGoogle();
              setState(() {
                if (_googleSignInHandler.auth.currentUser != null) {
                  isLogged = true;
                } else {
                  isLogged = false;
                }
              });
            } catch (e) {
              debugPrint("CircularAvatarButton error: $e");
            }
          }
          ;
          if (item == MenuItem.registration) {
            Navigator.of(context).pushNamed('/registration');
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              PopupMenuItem<MenuItem>(
                value: MenuItem.login,
                child: isLogged ? const Text("Log out") : const Text("Log In"),
              ),
              PopupMenuItem<MenuItem>(
                value: MenuItem.registration,
                child: isLogged
                    ? const Text("Registration")
                    : const Text("Registration"),
              )
            ],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: IconButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
            icon: const Icon(
              Icons.person_rounded,
              color: Colors.white,
            ),
          ),
          // child: isLogged
          //   ? CircleAvatar(
          //     backgroundImage: NetworkImage(
          //       _googleSignInHandler.auth.currentUser!.photoURL!,
          //     ),
          //   )
          //   : IconButton(
          //     onPressed: null,
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0),),),
          //     ),
          //     icon: const Icon(
          //       Icons.person_rounded, color: Colors.white,),
          //   ),
        ));
  }
}
