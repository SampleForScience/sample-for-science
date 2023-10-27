import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sample/firebase_options.dart';
import 'package:sample/ui/views/dashboard_page.dart';
import 'package:sample/ui/views/login_page.dart';
import 'package:sample/ui/views/new_sample_page.dart';
import 'package:sample/ui/views/registration_page.dart';
import 'package:sample/ui/views/sample_page.dart';
import 'package:sample/ui/views/search_page.dart';
import 'package:sample/ui/views/update_sample_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255,55,98,118)),
    ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/registration': (context) => const RegistrationPage(),
        '/sample': (context) => const SamplePage(),
        '/new-sample': (context) => const NewSamplePage(),
        '/update-sample': (context) => const UpdateSamplePage(),
        '/search': (context) => const SearchPage(),
      },
    );
  }
}
