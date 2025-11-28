import 'dart:async';

import 'package:flutter/material.dart';
import 'package:softmed24h/src/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaItem {
  final String imagePath;
  final String url;

  MediaItem({required this.imagePath, required this.url});
}

class MediaSection extends StatefulWidget {
  const MediaSection({super.key});

  @override
  State<MediaSection> createState() => _MediaSectionState();
}

class _MediaSectionState extends State<MediaSection> {
  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  final List<MediaItem> _mediaItems = [
    MediaItem(
      imagePath: 'assets/images/banner.png',
      url: 'https://globo.com',
    ), // Placeholder URL
    MediaItem(
      imagePath: 'assets/images/banner.png',
      url: 'https://r7.com',
    ), // Placeholder URL
    MediaItem(
      imagePath: 'assets/images/banner.png',
      url: 'https://uol.com.br',
    ), // Placeholder URL
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentIndex < _mediaItems.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      color: colors.primaryGreen,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            'SOFTMED24H NA MÍDIA:',
            style: TextStyle(
              color: Colors.white, // Changed to white as primaryGreen is the background
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '(clique na logo do portal para abrir a matéria)',
            style: TextStyle(color: colors.primaryBlue, fontSize: 18),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                0.4, // Adjust height proportionally
            child: PageView.builder(
              controller: _pageController,
              itemCount: _mediaItems.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _mediaItems[index];
                return GestureDetector(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(item.url))) {
                      await launchUrl(Uri.parse(item.url));
                    }
                  },
                  child: Image.asset(item.imagePath),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _mediaItems.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _pageController.animateToPage(
                  entry.key,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeIn,
                ),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(
                      (Theme.of(context).brightness == Brightness.dark
                          ? 255
                          : 0), // R
                      (Theme.of(context).brightness == Brightness.dark
                          ? 255
                          : 0), // G
                      (Theme.of(context).brightness == Brightness.dark
                          ? 255
                          : 0), // B
                      (_currentIndex == entry.key ? 0.9 : 0.4), // Opacity
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
