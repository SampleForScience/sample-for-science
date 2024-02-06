import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReportBugButton extends StatefulWidget {
  const ReportBugButton({super.key});

  @override
  State<ReportBugButton> createState() => _ReportBugButtonState();
}

class _ReportBugButtonState extends State<ReportBugButton> {
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
          Icon(Icons.bug_report, color: Colors.white70),
          Text(" Report a bug", style: TextStyle(color: Colors.white70)),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => {},
                          child: const Text('Send',
                              style: TextStyle(fontSize: 16)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                  title: const Center(child: Text('Report a bug')),
                  content: Container(
                    height: 150,
                    width: 300,
                    child: Column(
                      children: [
                        Text("Describe in details the bug you found"),
                        Container(
                          width: 280,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: false,
                            ),
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
      },
    );
  }
}
