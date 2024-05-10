import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample/services/signInHandler.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({Key? key}) : super(key: key);

  @override
  _TermsOfUsePageState createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  late String packageVersion;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool termsAccepted = false;
  late SignInHandler _signInHandler;

  @override
  void initState() {
    super.initState();
    _signInHandler = SignInHandler(context);
  }

  Future<void> _acceptTerms() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        print('Usuário atual: ${currentUser.uid}');
        await _firestore.collection('users').doc(currentUser.uid).update({
          'termsAccepted': true,
        });
        setState(() {
          termsAccepted = true;
        });
        print('Termos aceitos com sucesso.');

        Navigator.pushReplacementNamed(context, '/search');
      } catch (e) {
        print('Erro ao aceitar os termos: $e');
      }
    } else {
      print('Usuário atual não encontrado.');
    }
  }

  Future<void> _init() async {
    await Firebase.initializeApp();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      packageVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 153, 153, 236)
              ])),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 48),
                  Text(
                    'Terms of Use',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'This software is not intended for commercial purposes. The use of this software for any commercial purpose, including, but not limited to:\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '- Sale of products or services\n- Advertising or marketing\n- Collection of customer data\n- Use in a business environment\n',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'Is strictly prohibited.\nBy using this software, you agree to:\n'),
                  Text(
                      '- Not use it for any commercial purpose\n- Not distribute it to third parties without the prior written consent of the developer\n- Not remove or modify any copyright notices or trademarks of the software\n',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                      'The developer is not liable for any damages or losses incurred as a result of using this software for commercial purposes.\n'),
                  Text(
                      'If you are interested in using this software for commercial purposes, please contact the developer to discuss licensing options.\n'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: termsAccepted ? null : _acceptTerms,
                        child:
                            Text(termsAccepted ? 'Terms Accepted' : 'I Agree'),
                      ),
                      ElevatedButton(
                          onPressed: _signInHandler.signInWithGoogle,
                          child: const Text('Logout'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
