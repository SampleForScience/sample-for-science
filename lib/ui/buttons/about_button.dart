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
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("About"),
            content: const Text("Version: 0.1.5"),
            actions: <Widget>[
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("Ok")),
            ],
          ),
        );
      },
    );
  }
}
