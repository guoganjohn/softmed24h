import 'package:flutter/material.dart';
import 'package:softmed24h/src/screens/landing/sections/faq_section.dart';
import 'package:web/web.dart' as web;

void main() {
  runApp(const DoutorBeneficiosApp());
}

class DoutorBeneficiosApp extends StatelessWidget {
  const DoutorBeneficiosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeleClin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary Brand Colors based on the medical/health theme
        primaryColor: const Color(0xFF0056D2), // Deep Blue
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0056D2),
          secondary: const Color(0xFF00C853), // Success Green for CTAs
          surface: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A237E),
            height: 1.1,
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper to determine layout based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Scaffold(
      // Sticky header for Desktop, standard AppBar for mobile
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 2,
              title: const LogoWidget(fontSize: 20),
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Color(0xFF0056D2)),
                  onPressed: () {},
                ),
              ],
            )
          : const PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: DesktopNavBar(),
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(isMobile: isMobile),
            StatsSection(isMobile: isMobile),
            BenefitsSection(isMobile: isMobile),
            CtaSection(isMobile: isMobile),
            FAQSection(),
            FooterSection(isMobile: isMobile),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// NAVIGATION BAR (Desktop)
// -----------------------------------------------------------------------------

class DesktopNavBar extends StatelessWidget {
  const DesktopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          const LogoWidget(),
          const Spacer(),

          ElevatedButton(
            onPressed: () {
              web.window.location.href = 'https://cliente.softmed24h.com/login';
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              side: BorderSide(color: Theme.of(context).primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
            child: const Text('ENTRAR'),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              web.window.location.href =
                  'https://cliente.softmed24h.com/cadastro';
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'QUERO ME CONSULTAR!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  const NavItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final double fontSize;
  const LogoWidget({super.key, this.fontSize = 26});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height:
          fontSize * 1.5, // Adjust height based on fontSize for responsiveness
    );
  }
}

// -----------------------------------------------------------------------------
// HERO SECTION
// -----------------------------------------------------------------------------

class HeroSection extends StatelessWidget {
  final bool isMobile;
  const HeroSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF4F8FD), // Light blue tint
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 100,
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text Content
          Expanded(
            flex: isMobile ? 0 : 5,
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'SAÚDE RÁPIDA, SEGURA E DIGITAL!',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Cuidar da sua saúde nunca foi tão simples e barato.',
                  style: isMobile
                      ? Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 32)
                      : Theme.of(context).textTheme.displayLarge,
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                ),
                const SizedBox(height: 24),
                Text(
                  'Consulta, Receitas, Atestados, Exames',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                ),
                const SizedBox(height: 24),
                Text(
                  'Imediatamente no seu celular!',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: isMobile
                      ? WrapAlignment.center
                      : WrapAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        web.window.location.href =
                            'https://cliente.softmed24h.com/cadastro';
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 22,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'QUERO ME CONSULTAR!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isMobile) const Spacer(flex: 1),
          // Hero Image (Placeholder using Container)
          if (!isMobile)
            Expanded(
              flex: 5,
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    fit: BoxFit.contain,
                    // Using a placeholder image from Unsplash source
                    image: AssetImage('assets/images/ad.png'),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(
                        51,
                        33,
                        150,
                        243,
                      ), // Colors.blue.withOpacity(0.2) approx
                      blurRadius: 30,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STATS SECTION
// -----------------------------------------------------------------------------

class StatsSection extends StatelessWidget {
  final bool isMobile;
  const StatsSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2f3773),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          StatItem(value: '+200k', label: 'Consultas'),
          StatItem(value: '+50', label: 'Médicos'),
          StatItem(value: '+150k', label: 'Atestados e receitas'),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String value;
  final String label;
  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// BENEFITS SECTION
// -----------------------------------------------------------------------------

class BenefitsSection extends StatelessWidget {
  final bool isMobile;
  const BenefitsSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 80,
      ),
      child: Column(
        children: [
          const Text(
            'Por que escolher o TeleClin?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Economia real e atendimento de qualidade para você e sua família.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: const [
              BenefitCard(
                icon: Icons.video_call_rounded,
                title: 'Telemedicina 24h',
                description:
                    'Atendimento médico na palma da mão, sem sair de casa.',
              ),
              BenefitCard(
                icon: Icons.percent_rounded,
                title: 'Receitas, Atestados e Exames',
                description: 'Documentos diretamente no seu celular',
              ),
              BenefitCard(
                icon: Icons.medication_rounded,
                title: 'Sem Burocracia',
                description: 'Rapidez e segurança, com validade em todo Brasil.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BenefitCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0056D2), size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PRICING SECTION
// -----------------------------------------------------------------------------

class PricingSection extends StatelessWidget {
  final bool isMobile;
  const PricingSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 80,
      ),
      child: Column(
        children: [
          const Text(
            'Escolha o plano ideal',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              PricingCard(
                title: 'Individual',
                price: '29,90',
                features: const [
                  'Titular apenas',
                  'Consultas com desconto',
                  'Exames laboratoriais',
                  'Sem carência',
                ],
                isPopular: false,
                isMobile: isMobile,
              ),
              PricingCard(
                title: 'Familiar',
                price: '49,90',
                features: const [
                  'Titular + 3 Dependentes',
                  'Telemedicina Grátis',
                  'Odontologia (Avaliação)',
                  'Clube de Vantagens',
                  'Sem carência',
                ],
                isPopular: true,
                isMobile: isMobile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isPopular;
  final bool isMobile;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.isPopular,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: isMobile ? double.infinity : 350,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: isPopular
                ? Border.all(color: const Color(0xFF00C853), width: 2)
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'R\$',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0056D2),
                    ),
                  ),
                  const Text(
                    '/mês',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ...features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF00C853),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(feature, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular
                        ? const Color(0xFF00C853)
                        : const Color(0xFF0056D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ASSINAR AGORA',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: -15,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'MAIS VENDIDO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// CTA SECTION
// -----------------------------------------------------------------------------

class CtaSection extends StatelessWidget {
  final bool isMobile;
  const CtaSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFf6fafe),
      padding: const EdgeInsets.symmetric(
        vertical: 40,
      ), // Overall section padding
      child: Column(
        children: [
          Text(
            'Se consulte agora mesmo:',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2f3773),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? 20
                  : 80, // Keep horizontal margin for the inner box
              // Removed vertical margin from here, handled by outer container padding
            ),
            padding: EdgeInsets.all(isMobile ? 30 : 50),
            decoration: BoxDecoration(
              color: const Color(0xFF2f3773),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Button Section
                ElevatedButton(
                  onPressed: () {
                    web.window.location.href =
                        'https://cliente.softmed24h.com/cadastro';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf58634), // Orange
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'QUERO ME CONSULTAR',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                if (isMobile)
                  const SizedBox(height: 30)
                else
                  const SizedBox(width: 60),

                // Price & Security Section
                Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    // Compra Segura Badge
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Image.asset(
                        'assets/images/safepurchase.png',
                        height: 90, // Adjust height as needed to match the design
                      ),
                    ),
                    const Text(
                      'APENAS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: isMobile
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          'R\$ ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '49,90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// FOOTER
// -----------------------------------------------------------------------------

class FooterSection extends StatelessWidget {
  final bool isMobile;
  const FooterSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2f3773),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 60,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isMobile ? 1 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LogoWidget(fontSize: 22),
                    const SizedBox(height: 20),
                    const Text(
                      'A telemedicina mais rápida e segura do Brasil!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (!isMobile) ...[
                const Spacer(),
                const FooterColumn(
                  title: 'Institucional',
                  links: ['Sobre nós', 'Carreiras', 'Imprensa'],
                ),
                const SizedBox(width: 60),
                const FooterColumn(
                  title: 'Ajuda',
                  links: ['Fale Conosco', 'FAQ', 'Política de Privacidade'],
                ),
              ],
            ],
          ),
          const SizedBox(height: 60),
          Divider(color: Colors.grey.shade800),
          const SizedBox(height: 30),
          const Text(
            '© 2025 TeleClin. Todos os direitos reservados.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  const FooterColumn({super.key, required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              link,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
