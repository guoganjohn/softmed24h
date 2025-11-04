import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TokenErrorScreen extends StatelessWidget {
  final String message;

  const TokenErrorScreen({
    super.key,
    this.message =
        'O link de redefinição de senha é inválido ou expirou. Por favor, solicite um novo link.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erro de Token')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Ir para a Tela de Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.go('/forgot-password');
                },
                child: const Text('Solicitar Novo Link de Redefinição'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
