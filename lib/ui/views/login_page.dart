import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sample/ui/widgets/google_login_button.dart';

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
              // vai pra deshboard page depois do widget carregar
              Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
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
                        padding: EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Log in To Sample',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 30, fontFamily: 'Arial')
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: GoogleLoginButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Define o raio das bordas
                            ),
                          ),
                          onPressed: null,
                          child: const SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(FontAwesomeIcons.apple),
                                SizedBox(width: 15,),
                                Text("Sign in with Apple",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
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
