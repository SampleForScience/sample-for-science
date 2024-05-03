import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({Key? key}) : super(key: key);

  @override
  _TermsOfUsePageState createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _termsAccepted = false;

  Future<void> _acceptTerms() async {
    // Salvando a aceitação dos termos no Firebase
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        print('Usuário atual: ${currentUser.uid}');
        await _firestore.collection('users').doc(currentUser.uid).update({
          'termsAccepted': true,
        });
        setState(() {
          _termsAccepted = true;
        });
        print('Termos aceitos com sucesso.');
        // Redirecionar o usuário para a próxima página (por exemplo, a página de pesquisa)
        Navigator.pushReplacementNamed(context, '/search');
      } catch (e) {
        print('Erro ao aceitar os termos: $e');
        // Tratar o erro, se necessário
      }
    } else {
      print('Usuário atual não encontrado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Use'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Use',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'EU AUTORIZO USAREM MEUS DADOS PRO QUE QUISEREM\n PROMETO TAMBÉM NÃO PROCESSAR NINGUÉM\n\n Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus libero ac velit tincidunt, et pharetra elit sollicitudin. Nam auctor dolor id eleifend egestas. Nam congue mauris nec lorem blandit, nec dapibus metus tempor. Donec aliquet posuere est sit amet tempus. Nam porta vehicula enim, id posuere lorem convallis vel. Integer dictum tortor at purus mattis, nec interdum neque lobortis. Vivamus in feugiat nunc. In sagittis malesuada orci sit amet venenatis. Duis euismod est quis malesuada feugiat. Proin tempus dolor quis leo viverra, in malesuada justo tempus. Maecenas auctor, ipsum nec pharetra rhoncus, sapien dui laoreet orci, eget lacinia nisl sapien in risus. Integer quis purus at dolor euismod sollicitudin. Phasellus non scelerisque lacus, nec ullamcorper orci. Proin semper sodales enim id interdum.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _termsAccepted ? null : _acceptTerms,
              child: Text(_termsAccepted ? 'Terms Accepted' : 'I Agree'),
            ),
          ],
        ),
      ),
    );
  }
}
