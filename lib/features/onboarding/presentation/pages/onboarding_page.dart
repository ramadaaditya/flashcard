import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flashcard/core/constants/app_constants.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingData(
      imagePath: 'assets/images/onboarding1.png',
      title: 'Kelola Tugas dengan Mudah',
      subtitle:
          'Atur semua tugas dan prioritasmu dalam satu tempat.\n'
          'Tidak ada lagi pekerjaan yang terlewat.',
      color: Color(0xFF6C63FF),
    ),
    _OnboardingData(
      imagePath: 'assets/images/onboarding2.png',
      title: 'Fokus & Istirahat Seimbang',
      subtitle:
          'Gunakan Pomodoro dan Focus Session untuk produktivitas maksimal.\n'
          'Kerja keras, istirahat cerdas.',
      color: Color(0xFF03DAC6),
    ),
    _OnboardingData(
      imagePath: 'assets/images/onboarding3.png',
      title: 'Lacak Waktu & Progresmu',
      subtitle:
          'Lihat statistik harian dan mingguan untuk memahami kebiasaanmu.\n'
          'Tingkatkan produktivitas setiap hari.',
      color: Color(0xFFFF6584),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompleteKey, true);
    if (mounted) {
      context.go('/home');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _OnboardingContent(data: _pages[index]);
            },
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section: Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      child: const Text(
                        'Lewati',
                        style: TextStyle(
                          color: Colors.white, // Ubah jadi putih agar kontras dengan gambar
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom section: Dots & Button
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dots indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => _DotIndicator(isActive: index == _currentPage),
                        ),
                      ),
                    ),

                    // Bottom button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _nextPage,
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? 'Mulai Sekarang'
                                : 'Selanjutnya',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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

class _OnboardingData {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _OnboardingContent extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          data.imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),

        // Gradient overlay agar teks tetap terbaca
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
              stops: const [0.4, 1.0],
            ),
          ),
        ),

        // Title & subtitle di bagian bawah
        Positioned(
          left: 24,
          right: 24,
          bottom: 160,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
