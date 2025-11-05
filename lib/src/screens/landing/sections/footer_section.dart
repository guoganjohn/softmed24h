import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            'A Plataforma SoftMed24h é administrada pela SoftMed24h Brazil.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'CRM-PB 3562/RN',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 10 : 12,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Política de Privacidade | Termos e Condições de Uso | Fale Conosco',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Copyright © ${DateTime.now().year} - SoftMed24h',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
