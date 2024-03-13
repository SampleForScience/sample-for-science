import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

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
                          text: 'We are in a testing period and only registered emails can access the "Sample For Science" app, find out more at',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                        TextSpan(
                          text: 'sampleforscience.org',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('https://sampleforscience.org/'));
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  child: const Text("Return to login page")),
              ],
            ),
          ),
        ));
  }
}
