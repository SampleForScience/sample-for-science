import 'package:flutter/material.dart';
import 'package:sample/ui/widgets/buttons/circular_avatar_button.dart';

class NewSamplePage extends StatefulWidget {
  const NewSamplePage({super.key});

  @override
  State<NewSamplePage> createState() => _NewSamplePageState();
}

class _NewSamplePageState extends State<NewSamplePage> with SingleTickerProviderStateMixin {
  List<Tab> tabs = <Tab>[
    const Tab(text: 'Basics',),
    const Tab(text: 'Results',),
    const Tab(text: 'Suggestions',),
    const Tab(text: 'Hazard',),
  ];

  late TabController _tabController;

  void _handleTabSelection() {
    setState(() {
      _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Sample"),
        centerTitle: true,
        actions: const [
          CircularAvatarButton()
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((Tab tab) {
          return Center(child: Text(tab.text!));
        }).toList(),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (_tabController.index > 0) ElevatedButton(
              onPressed: () {
                setState(() {
                  _tabController.index--;
                });
                _tabController.animateTo(_tabController.index);
              },
              child: const Text("Back"),
            ),
            if (_tabController.index < tabs.length - 1) ElevatedButton(
              onPressed: () {
                setState(() {
                  _tabController.index++;
                });
                _tabController.animateTo(_tabController.index);
              },
              child: const Text("Next"),
            ),
            if (_tabController.index == tabs.length - 1) ElevatedButton(
              onPressed: () {},
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}


