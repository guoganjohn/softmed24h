import 'package:flutter/material.dart';
import 'package:softmed24h/src/utils/app_colors.dart';
import 'package:web/web.dart' as web;

class TestimonialSection extends StatelessWidget {
  const TestimonialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      color: AppColors.primary,
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
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              web.window.location.href =
                  'https://cliente.softmed24h.com/cadastro';
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            child: Text(
              'QUERO ME CONSULTAR',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
