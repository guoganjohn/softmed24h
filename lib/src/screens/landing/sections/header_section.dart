import 'package:flutter/material.dart';
import 'package:softmed24h/src/utils/app_colors.dart';
import 'package:softmed24h/src/widgets/app_button.dart';
import 'package:web/web.dart' as web;

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    return Container(
      color: colors.primaryGreen,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          // --- Navigation Bar / Top Header ---
          LayoutBuilder(
            builder: (context, constraints) {
              // Navigation bar content should be constrained in the same way as the hero content for alignment.
              final navContent = Container(
                color: colors.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/logo.png', height: 40),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SoftMed24h',
                              style: TextStyle(
                                color: colors.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Nosso plano é a sua saúde',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            web.window.location.href =
                                'https://cliente.softmed24h.com/login';
                          },
                          child: Text(
                            'ENTRAR',
                            style: TextStyle(color: colors.primaryGreen),
                          ),
                        ),
                        const SizedBox(width: 10),
                        AppButton(
                          label: 'QUERO ME CONSULTAR',
                          width: 260,
                          height: 36,
                          fontSize: 14,
                          onPressed: () {
                            web.window.location.href =
                                'https://cliente.softmed24h.com/cadastro';
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );

              if (constraints.maxWidth < 600) {
                // Mobile Layout: Logo on top, buttons below
                return Container(
                  color: colors.primaryBlue,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the logo and text
                        children: [
                          Image.asset('assets/images/logo.png', height: 40),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MeuMed',
                                style: TextStyle(
                                  color: colors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'Nosso plano é a sua saúde',
                                style: TextStyle(
                                  color: Colors.black, // AppColors.text replaced with Colors.black
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              web.window.location.href =
                                  'https://cliente.softmed24h.com/login';
                            },
                            child: Text(
                              'ENTRAR',
                              style: TextStyle(color: colors.primaryGreen),
                            ),
                          ),
                          const SizedBox(width: 10),
                          AppButton(
                            label: 'QUERO ME CONSULTAR',
                            width: 260,
                            height: 36,
                            fontSize: 14,
                            onPressed: () {
                              web.window.location.href =
                                  'https://cliente.softmed24h.com/cadastro';
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                // Desktop Layout: Constrain navigation width for large screens
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: navContent,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 40),
          // --- Hero Content Section (Constrained) ---
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1763,
              ), // Max width for content area
              child: Container(
                color: colors.primaryGreen,
                // Reduced horizontal padding to 10px on each side for mid-size desktop screens
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 40,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine if we are in a narrow desktop range (e.g., 600px to 1024px)
                    final isNarrowDesktop =
                        constraints.maxWidth > 600 &&
                        constraints.maxWidth < 1024;

                    if (constraints.maxWidth < 600) {
                      // Mobile Hero Layout: Text block above image
                      return Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  // The first part of the text
                                  Text(
                                    'Consultas médicas',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth < 400
                                          ? 20
                                          : 28,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  // The second, styled part of the text
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primaryBlue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '24h por dia!',
                                      style: TextStyle(
                                        fontSize: constraints.maxWidth < 400
                                            ? 20
                                            : 28,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'SEM SAIR DE CASA.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: colors.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '✓ Médico 24h\n✓ Atendimento imediato\n✓ Prescrição digital\n✓ Atestados e receitas\n✓ Tudo por apenas R\$ 49,90',
                                style: TextStyle(color: colors.primaryBlue),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'R\$ 49,90',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: colors.primaryBlue,
                                  fontWeight: FontWeight.bold,
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
                                  style: TextStyle(color: colors.primaryGreen),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Image.asset('images/doctor.png', height: 300),
                        ],
                      );
                    } else {
                      // Desktop Hero Layout: Text block next to image
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3, // Increased text priority
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // *** FIX: Changed Row to Wrap to allow title elements to break lines when space is tight ***
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing:
                                      14, // Horizontal space between elements
                                  runSpacing:
                                      10, // Vertical space between wrapped lines
                                  children: [
                                    // The first part of the text
                                    Text(
                                      'Consultas médicas',
                                      style: TextStyle(
                                        // Font size controlled by isNarrowDesktop flag
                                        fontSize: isNarrowDesktop ? 28 : 32,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primaryBlue,
                                      ),
                                    ),
                                    // The second, styled part of the text
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.primaryBlue,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '24h por dia!',
                                        style: TextStyle(
                                          // Font size controlled by isNarrowDesktop flag
                                          fontSize: isNarrowDesktop ? 28 : 32,
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'SEM SAIR DE CASA.',
                                  style: TextStyle(
                                    fontSize: isNarrowDesktop ? 20 : 22,
                                    color: colors.primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  '✓ Médico 24h\n✓ Atendimento imediato\n✓ Prescrição digital\n✓ Atestados e receitas\n✓ Tudo por apenas R\$ 49,90',
                                  style: TextStyle(
                                    color: colors.primaryBlue,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'R\$ 49,90',
                                  style: TextStyle(
                                    fontSize: isNarrowDesktop ? 24 : 28,
                                    color: colors.primaryBlue,
                                    fontWeight: FontWeight.bold,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'QUERO ME CONSULTAR',
                                    style: TextStyle(
                                      color: colors.primaryGreen,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ), // Reduced spacer width to 10px
                          // Image is constrained by Flexible and max width
                          Flexible(
                            flex: 1,
                            child: Image.asset(
                              'assets/images/doctor.png',
                              height: 350,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
