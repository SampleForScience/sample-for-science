import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/firebase_options.dart';
import 'package:sample/providers/sample_provider.dart';
import 'package:sample/ui/views/dashboard_page.dart';
import 'package:sample/ui/views/intructions_page.dart';
import 'package:sample/ui/views/login_page.dart';
import 'package:sample/ui/views/new_sample_page.dart';
import 'package:sample/ui/views/provider_page.dart';
import 'package:sample/ui/views/registration_page.dart';
import 'package:sample/ui/views/sample_page.dart';
import 'package:sample/ui/views/search_page.dart';
import 'package:sample/ui/views/testing_period.dart';
import 'package:sample/ui/views/update_sample_page.dart';
import 'package:sample/ui/views/users_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => SampleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Brightness platformBrightness = MediaQuery.of(context).platformBrightness;

    return MaterialApp(
      title: 'Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            //brightness: platformBrightness,
            seedColor: const Color.fromARGB(255, 55, 98, 118)),
      ),
      home: const DashboardPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/registration': (context) => const RegistrationPage(),
        '/sample': (context) => const SamplePage(),
        '/new-sample': (context) => const NewSamplePage(),
        '/update-sample': (context) => const UpdateSamplePage(),
        '/search': (context) => const SearchPage(),
        '/messages': (context) => const UsersPage(),
        '/provider': (context) => const ProviderPage(),
        '/instructions': (context) => const InstructionsPage(),
        '/testing': (context) => const TestingPeriodPage(),
      },
    );
  }
}
