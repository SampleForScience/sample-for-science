import 'package:flutter/material.dart';
import 'package:sample/ui/buttons/about_button.dart';
import 'package:sample/ui/buttons/drawer_logout_button.dart';

enum Highlight { dashboard, provide, search, messages, other }

class CustomDrawer extends StatefulWidget {
  final Highlight highlight;
  const CustomDrawer({super.key, required this.highlight});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: const Color.fromARGB(255, 55, 98, 118),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 245, 252, 255),
            ),
            child: Image(image: AssetImage("assets/logo.png")),
          ),
          Container(
            color: widget.highlight == Highlight.dashboard
              ? const Color.fromARGB(255, 245, 252, 255)
              : const Color.fromARGB(255, 55, 98, 118),
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.apps,
                    color: widget.highlight == Highlight.dashboard
                      ? Colors.black87
                      : Colors.white70,
                  ),
                  Text(
                    " Dashboard",
                    style: TextStyle(
                      color: widget.highlight == Highlight.dashboard
                          ? Colors.black87
                          : Colors.white70,
                    )
                  ),
                ],
              ),
              onTap: () {
                debugPrint("Dashboard clicked");
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil("/dashboard", (route) => false);
              },
            ),
          ),
          Container(
            color: widget.highlight == Highlight.provide
              ? const Color.fromARGB(255, 245, 252, 255)
              : const Color.fromARGB(255, 55, 98, 118),
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: widget.highlight == Highlight.provide
                      ? Colors.black87
                      : Colors.white70,
                  ),
                  Text(
                    " Provide sample",
                    style: TextStyle(
                      color: widget.highlight == Highlight.provide
                        ? Colors.black87
                        : Colors.white70,
                    )
                  ),
                ],
              ),
              onTap: () {
                debugPrint("Provide sample clicked");
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/new-sample');
              },
            ),
          ),
          Container(
            color: widget.highlight == Highlight.search
              ? const Color.fromARGB(255, 245, 252, 255)
              : const Color.fromARGB(255, 55, 98, 118),
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: widget.highlight == Highlight.search
                      ? Colors.black87
                      : Colors.white70,
                  ),
                  Text(
                    " Search",
                    style: TextStyle(
                      color: widget.highlight == Highlight.search
                        ? Colors.black87
                        : Colors.white70,
                    )
                  )
                ],
              ),
              onTap: () {
                debugPrint("Search clicked");
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/search');
              },
            ),
          ),
          Container(
            color: widget.highlight == Highlight.messages
              ? const Color.fromARGB(255, 245, 252, 255)
              : const Color.fromARGB(255, 55, 98, 118),
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.messenger_outline_sharp,
                    color: widget.highlight == Highlight.messages
                      ? Colors.black87
                      : Colors.white70,
                  ),
                  Text(
                    " Messages",
                    style: TextStyle(
                      color: widget.highlight == Highlight.messages
                        ? Colors.black87
                        : Colors.white70,
                    )
                  ),
                ],
              ),
              onTap: () {
                debugPrint("Messages clicked");
                Navigator.pop(context);
              },
            ),
          ),
          const AboutButton(),
          const DrawerLogoutButton(),
        ],
      ),
    );
  }
}
