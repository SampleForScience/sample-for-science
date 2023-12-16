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
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(100, 199, 209, 241), // Cor da borda vermelha
                    width: 16.0, // Largura da borda
                  ),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: SvgPicture.asset(
                          "assets/logo.svg",
                          width: 300
                        )
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: GoogleLoginButton(),
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 16.0),
                      //   child: AppleLoginButton(),
                      // )
                    ]
                  ),
                )
              )
            );
          }
        },
      ),
    );
  }
}
