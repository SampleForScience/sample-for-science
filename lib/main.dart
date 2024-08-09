import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/firebase_options.dart';
import 'package:sample/providers/sample_provider.dart';
import 'package:sample/services/analytics_service.dart';
import 'package:sample/ui/views/dashboard_page.dart';
import 'package:sample/ui/views/intructions_page.dart';
import 'package:sample/ui/views/login_page.dart';
import 'package:sample/ui/views/new_sample_page.dart';
import 'package:sample/ui/views/provider_page.dart';
import 'package:sample/ui/views/registration_page.dart';
import 'package:sample/ui/views/sample_page.dart';
import 'package:sample/ui/views/search_page.dart';
import 'package:sample/ui/views/testing_period.dart';
import 'package:sample/ui/views/terms_of_use.dart';
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 55, 98, 118),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/registration': (context) => const RegistrationPage(),
        '/sample': (context) => const SamplePage(),
        '/new-sample': (context) => const NewSamplePage(),
        '/update-sample': (context) => const UpdateSamplePage(),
        '/messages': (context) => const UsersPage(),
        '/provider': (context) => const ProviderPage(),
        '/instructions': (context) => const InstructionsPage(),
        '/testing': (context) => const TestingPeriodPage(),
        '/terms': (context) => const TermsOfUsePage(),
        '/search': (context) {
          return FutureBuilder<bool>(
            future: checkTermsAccepted(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return const Scaffold(body: Center(child: Text('Error')));
              } else {
                final accepted = snapshot.data ?? false;
                // Mensagem de depuração
                return accepted ? const SearchPage() : const TermsOfUsePage();
              }
            },
          );
        },
      },
    );
  }
}

Future<bool> checkTermsAccepted() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return data['termsAccepted'] ?? false;
    } else {
      // Se o documento não existe, trata como se os termos não tivessem sido aceitos
      return false;
    }
  }
  // Se não houver usuário logado, também retorna false
  return false;
}
