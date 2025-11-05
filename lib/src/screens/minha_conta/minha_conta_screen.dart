import 'package:flutter/material.dart';

class MinhaContaScreen extends StatelessWidget {
  const MinhaContaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Conta')),
      body: const Center(child: Text('Minha Conta Screen')),
    );
  }
}
