import 'package:flutter/material.dart';
import 'package:softmed24h/src/utils/app_colors.dart';

class PlatformHighlightSection extends StatelessWidget {
  const PlatformHighlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      padding: const EdgeInsets.all(32),
      color: colors.primaryBlue,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 814) {
            return Column(
              children: [
                Text(
                  'A Melhor Plataforma de\nTelemedicina com o\natendimento mais rápido\ndo Brasil!',
                  style: TextStyle(
                    fontSize: constraints.maxWidth < 400 ? 24 : 34,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                VideoPlaceholder(), // VideoPlaceholder is now included in mobile layout
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'A Melhor Plataforma de\nTelemedicina com o\natendimento mais rápido\ndo Brasil!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: VideoPlaceholder()),
              ],
            );
          }
        },
      ),
    );
  }
}

class VideoPlaceholder extends StatelessWidget {
  const VideoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400, minWidth: 600),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
