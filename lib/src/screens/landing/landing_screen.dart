import 'package:flutter/material.dart';
import 'package:softmed24h/src/screens/landing/sections/faq_section.dart';
import 'package:softmed24h/src/screens/landing/sections/footer_section.dart';
import 'package:softmed24h/src/screens/landing/sections/header_section.dart';
import 'package:softmed24h/src/screens/landing/sections/how_it_works_section.dart';
import 'package:softmed24h/src/screens/landing/sections/media_section.dart';
import 'package:softmed24h/src/screens/landing/sections/platform_highlight_section.dart';
import 'package:softmed24h/src/screens/landing/sections/testimonial_section.dart';
import 'package:softmed24h/src/utils/app_colors.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      backgroundColor: colors.primaryBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            PlatformHighlightSection(),
            MediaSection(),
            HowItWorksSection(),
            TestimonialSection(),
            FAQSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
