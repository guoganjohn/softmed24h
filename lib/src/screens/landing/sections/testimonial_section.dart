import 'package:flutter/material.dart';
import 'package:softmed24h/src/utils/app_colors.dart';
import 'package:web/web.dart' as web;

class TestimonialSection extends StatelessWidget {
  const TestimonialSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      color: colors.primaryGreen,
      child: Column(
        children: [
          Text(
            '200 mil brasileiros atendidos e satisfeitos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Se consulte agora mesmo: R\$ 49,90',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 18,
              color: colors.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              web.window.location.href =
                  'https://cliente.softmed24h.com/cadastro';
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryBlue,
            ),
            child: Text(
              'QUERO ME CONSULTAR',
              style: TextStyle(
                color: colors.primaryGreen,
                fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
