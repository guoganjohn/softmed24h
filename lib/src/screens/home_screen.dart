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
      title: 'MeuMed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary Brand Colors based on the medical/health theme
        primaryColor: const Color(0xFF0089CD), // MEUMED Blue
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0089CD),
          secondary: const Color(0xFFF58634), // CTA Orange
          surface: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0089CD),
            height: 1.1,
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0089CD),
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
              backgroundColor: const Color(0xFF0089CD),
              surfaceTintColor: Colors.white,
              elevation: 2,
              title: const LogoWidget(fontSize: 20, isWhite: true),
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : const PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: DesktopNavBar(),
            ),
      endDrawer: isMobile ? const MobileDrawer() : null,
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
        color: const Color(0xFF0089CD),
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
          const LogoWidget(isWhite: true),
          const Spacer(),

          ElevatedButton(
            onPressed: () {
              web.window.location.href = 'https://meumed24h.agendar.cc/#/login';
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0089CD),
              foregroundColor: Colors.white,
              elevation: 0,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
            child: const Text('ENTRAR'),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              web.window.location.href =
                  'https://meumed24h.agendar.cc/#/cadastro';
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0089CD),
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
  final bool isWhite;
  const LogoWidget({super.key, this.fontSize = 26, this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    // Note: Assuming we might have a white logo version or just using the same one.
    // For now using the same asset. If 'isWhite' is true, and it's a PNG with transparency,
    // it might need a white filter or a different asset.
    // Since I don't have a specific 'logo_white.png', I will use the default.
    // Ideally, replace with: isWhite ? 'assets/images/logo_white.png' : 'assets/images/logo.png'
    return Image.asset(
      'assets/images/logo.png',
      height: fontSize * 1.5,
      // color: isWhite ? Colors.white : null, // Uncomment if logo supports color masking
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
        mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text Content
          Expanded(
            flex: isMobile ? 0 : 5,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (!isMobile)
                  Positioned(
                    top: -50,
                    left: -50,
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/images/coracao.png',
                        height: 400,
                      ),
                    ),
                  ),
                Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONSULTAS\nMÉDICAS 24H\nPOR DIA!',
                      style: isMobile
                          ? Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 32,
                                color: const Color(0xFFE53935), // Reddish for contrast like image
                                height: 1.0,
                              )
                          : Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: const Color(0xFFE53935),
                                height: 1.0,
                                fontWeight: FontWeight.w900,
                              ),
                      textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.asset(
                        'assets/images/other.png',
                        height: isMobile ? 30 : 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'SEM SAIR DE CASA',
                      style: isMobile
                          ? Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 24,
                                color: const Color(0xFF0089CD),
                              )
                          : Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: const Color(0xFF0089CD),
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    ),
                    const SizedBox(height: 24),
                    // Icons Placeholder Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: isMobile
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: const [
                          _FeatureIcon(
                              icon: Icons.medical_services_outlined,
                              label: 'Médicos\n24h'),
                          SizedBox(width: 15),
                          _FeatureIcon(
                              icon: Icons.description_outlined,
                              label: 'Atestado\ne receitas'),
                          SizedBox(width: 15),
                          _FeatureIcon(
                              icon: Icons.history_toggle_off,
                              label: 'Use\nagora'),
                          SizedBox(width: 15),
                          _FeatureIcon(
                              icon: Icons.smartphone, label: 'Suporte\ntotal'),
                          SizedBox(width: 15),
                          _FeatureIcon(
                              icon: Icons.credit_card,
                              label: 'Pagamento\nseguro'),
                          SizedBox(width: 15),
                          _FeatureIcon(
                              icon: Icons.people_outline,
                              label: 'Todas as\nidades'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: isMobile ? Alignment.center : Alignment.centerLeft,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            web.window.location.href =
                                'https://meumed24h.agendar.cc/#/cadastro';
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF29B6F6), // Cyan/Light Blue
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
              ],
            ),
          ),
          // Hero Image
          if (!isMobile)
            Expanded(
              flex: 5,
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    fit: BoxFit.contain,
                    // Using doctor.png as inferred from the banner style request
                    image: AssetImage('assets/images/doctor.png'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0089CD), size: 30),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF0089CD))),
      ],
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
      color: const Color(0xFF0089CD),
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
          style: const TextStyle(color: Colors.white, fontSize: 16),
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
            'Por que escolher o MEUMED?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0089CD),
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
                icon: Icons.description_outlined,
                title: 'Receitas, Atestados e Exames',
                description: 'Documentos diretamente no seu celular',
              ),
              BenefitCard(
                icon: Icons.local_hospital_outlined,
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
              color: const Color(0xFFE1F5FE), // Lighter blue
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0089CD), size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0089CD),
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
              color: Color(0xFF0089CD),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? 20
                  : 80, // Keep horizontal margin for the inner box
            ),
            padding: EdgeInsets.all(isMobile ? 30 : 50),
            decoration: BoxDecoration(
              color: const Color(0xFF0089CD),
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
                        'https://meumed24h.agendar.cc/#/cadastro';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF58634), // Orange
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
                        height: 80, // Adjust height as needed to match the design
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
      color: const Color(0xFF0089CD), // MEUMED Blue
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
                  children: const [
                     LogoWidget(fontSize: 22, isWhite: true),
                     SizedBox(height: 20),
                     Text(
                      'A telemedicina mais rápida e segura do Brasil!',
                      style: TextStyle(color: Colors.white70),
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
          Divider(color: Colors.white30),
          const SizedBox(height: 30),
          const Text(
            '© 2025 MEUMED. Todos os direitos reservados.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
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
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0089CD),
            ),
            child: Center(
              child: const LogoWidget(isWhite: true, fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    web.window.location.href = 'https://meumed24h.agendar.cc/#/login';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0089CD),
                    side: const BorderSide(color: Color(0xFF0089CD)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('ENTRAR'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    web.window.location.href =
                        'https://meumed24h.agendar.cc/#/cadastro';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0089CD),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'QUERO ME CONSULTAR!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
