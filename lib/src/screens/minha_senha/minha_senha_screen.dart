import 'package:flutter/material.dart';

class MinhaSenhaScreen extends StatelessWidget {
  const MinhaSenhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Senha')),
      body: const Center(child: Text('Minha Senha Screen')),
    );
  }
}
