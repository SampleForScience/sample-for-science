import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample/ui/buttons/apple_login_button.dart';
import 'package:sample/ui/buttons/google_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = FirebaseAuth.instance;

  Future<bool> checkUserLoggedIn() async {
    return auth.currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(context, '/search', (route) => false);
            });
            return Container();
          } else {
            return
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      child: SvgPicture.asset(
                        "assets/logo.svg",
                        width: 225
                      )
                    ),
                    const SizedBox(height: 24,),
                    const GoogleLoginButton(),
                    const SizedBox(height: 8,),
                    const AppleLoginButton(),
                  ]
                )
            );
          }
        },
      ),
    );
  }
}