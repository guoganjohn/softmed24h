import 'package:flutter/material.dart';

class VirtualQueueScreen extends StatelessWidget {
  const VirtualQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fila de Atendimento')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Sua posição na fila é:', style: TextStyle(fontSize: 24)),
            Text(
              '1',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
