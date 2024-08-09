import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sample/services/analytics_service.dart';
import 'package:sample/ui/buttons/apple_login_button.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({super.key});

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {

  @override
  void initState() {
    super.initState();
    AnalyticsService.screenView("Intructions page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'We need you to share your email so that your account can be created. Remove the "Sample for Science" app from your apps with "Sign in with Apple" by following the steps below, then log in again and agree to share your email so that your account can be successfully created.\n',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(height: 30,)),
                        const TextSpan(
                          text: '1. Log in at ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                        TextSpan(
                          text: 'appleid.apple.com',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('https://appleid.apple.com'));
                            },
                        ),
                        const TextSpan(
                          text: '\n3. In "Sign in and security", click on "Sign in with Apple"',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                        const TextSpan(
                          text: '\n4. Click on "Sample For Science"',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                        const TextSpan(
                          text: '\n5. Click on "Stop using sign in with Apple"',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                        const TextSpan(
                          text: '\n6. Confirm by clicking on "Stop using"',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                        const TextSpan(
                          text: '\n7. Return to the app "Sample For Science", log in again and agree to share the email',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              const Center(child: AppleLoginButton()),
            ],
          ),
        ),
      ));
  }
}
