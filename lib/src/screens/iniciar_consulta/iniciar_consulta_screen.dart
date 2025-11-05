import 'package:flutter/material.dart';

class IniciarConsultaScreen extends StatelessWidget {
  const IniciarConsultaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Consulta')),
      body: const Center(child: Text('Iniciar Consulta Screen')),
    );
  }
}
