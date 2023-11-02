import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
          applicationIcon: const SizedBox(
            height: 100,
            child: Image(image: AssetImage("assets/logo.png"))
          ),
        );
      },
    );
  }
}
