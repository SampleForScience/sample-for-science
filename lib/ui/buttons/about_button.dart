import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutButton extends StatefulWidget {
  const AboutButton({super.key});

  @override
  State<AboutButton> createState() => _AboutButtonState();
}

class _AboutButtonState extends State<AboutButton> {
  late String packageVersion;
  Future<void> getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      packageVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    getPackageVersion();
    super.initState();
  }

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
          applicationVersion: packageVersion,
          applicationIcon: SizedBox(
            height: 100,
            child: SvgPicture.asset("assets/logo.svg",
              height: 100,
              width: 100,
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
              launchUrl(Uri.parse("https://www.sampleforscience.org"));
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
