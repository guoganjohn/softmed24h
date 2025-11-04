import 'package:flutter/material.dart';

class EmailSentScreen extends StatelessWidget {
  const EmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-mail Enviado')),
      body: Center(child: Text('Conteúdo da Tela de E-mail Enviado')),
    );
  }
}
