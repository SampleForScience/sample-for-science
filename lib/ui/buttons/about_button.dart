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
            child: SvgPicture.asset("assets/logo.svg",
              height: 100, // Defina a altura desejada
              width: 100, // Defina a largura desejada
            ),
          ),
          applicationLegalese: "© 2023 Sample. All rights reserved",
          children: [
            const SizedBox(height: 16),
        SizedBox(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Ajusta o alinhamento para a esquerda
          children: [
          Text(
          'For more information, visit: ',
          style: DefaultTextStyle.of(context).style,
          ),

          GestureDetector(
          onTap: () {
          launchUrl('https://www.sampleforscience.org' as Uri);
          },
          child: const Text(
          'Sample For Science',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            decoration: TextDecoration.underline,

                          ),
                      ),
                        ),
                      ],
          ),
        ),

          ],
        );
        ;
      },
    );
  }
}
