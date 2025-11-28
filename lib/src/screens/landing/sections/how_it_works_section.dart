import 'package:flutter/material.dart';
import 'package:softmed24h/src/utils/app_colors.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text(
            'COMO FUNCIONA?',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20, // Horizontal space between items
            runSpacing: 20, // Vertical space between lines
            alignment: WrapAlignment.center,
            children: const [
              HowItWorksStep(
                number: '1',
                text:
                    'Faça seu cadastro em nossa plataforma de forma rápida e simples.',
              ),
              HowItWorksStep(
                number: '2',
                text:
                    'Efetue o pagamento e comece seu atendimento médico na mesma hora.',
              ),
              HowItWorksStep(
                number: '3',
                text:
                    'Sempre que precisar de atendimento médico é só acessar nossa plataforma.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HowItWorksStep extends StatelessWidget {
  final String number;
  final String text;

  const HowItWorksStep({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return SizedBox(
      width: 300, // Fixed width for items in Wrap layout
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none, // Allows the circle to overflow
          children: [
            // The Dark Blue Description Box
            Container(
              margin: const EdgeInsets.only(
                top: 30,
              ), // Push the box down to make space for the circle
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: colors.primaryGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 180, // Fixed height for visual consistency
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            // The Rounded Number Circle
            Positioned(
              top: 0,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colors.primaryGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primaryBlue!, width: 1),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
