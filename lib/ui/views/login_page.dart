import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample/services/analytics_service.dart';
import 'package:sample/ui/buttons/apple_login_button.dart';
import 'package:sample/ui/buttons/google_login_button.dart';
import 'package:super_banners/super_banners.dart';

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
  void initState() {
    super.initState();
    AnalyticsService.screenView("Login page");
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
              Navigator.pushNamedAndRemoveUntil(
                  context, '/search', (route) => false);
            });
            return Container();
          } else {
            return Container(
              decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 61, 61, 206),
              ], center: Alignment.center, radius: 1.6)),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const SizedBox(
                      height: 48,
                    ),
                    Stack(
                      children: [
                        CornerBanner(
                          bannerPosition: CornerBannerPosition.topLeft,
                          bannerColor: Colors.red,
                          child: Text("Beta",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        Container(
                            child:
                                SvgPicture.asset("assets/logo.svg", width: 325))
                      ],
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    const GoogleLoginButton(),
                    const SizedBox(
                      height: 16,
                    ),
                    const AppleLoginButton(),
                  ])),
            );
          }
        },
      ),
    );
  }
}
