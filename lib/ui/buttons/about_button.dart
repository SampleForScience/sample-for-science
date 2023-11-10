import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Row(
        children: [
          Icon(Icons.info, color: Colors.white70),
          Text(" About", style: TextStyle(color: Colors.white70)),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        showAboutDialog(
          context: context,
          applicationName: "Sample For Science",
          applicationVersion: "0.1.6",
          applicationIcon: SizedBox(
            height: 100,
            child: Image.asset("assets/logo.png"),
          ),
          applicationLegalese: "www.sampleforscience.org",
          children: [
            SizedBox(height: 16),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Ajusta o alinhamento para a esquerda
        children: [
        Text(
        'For more information, visit: ',
        style: DefaultTextStyle.of(context).style,
        ),

        GestureDetector(
        onTap: () {
        launch('https://www.sampleforscience.org');
        },
        child: Text(
        'Sample For Science',
        style: TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        ),
        ),
        ),
        ],
        ),

          ],
        );
        ;
      },
    );
  }
}
