import 'package:flutter/material.dart';

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
            child: const Image(image: AssetImage("assets/logo.png"))
          ),
        );
      },
    );
  }
}
